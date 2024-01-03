class ArticleUnitsLib
  @un_ece_20_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-20-remastered.yml', Rails.root))).result)
  @un_ece_21_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-21.yml', Rails.root))).result)

  def self.untranslated_units
    return @untranslated_units unless @untranslated_units.nil?

    options = {}

    @un_ece_20_units.each do |unit|
      code = unit['CommonCode']
      base_unit = unit['conversion']['base_units'].nil? ? nil : unit['conversion']['base_units'][0]
      options[code] = { name: unit['Name'], description: unit['Description'], baseUnit: base_unit, conversionFactor: unit['conversion']['factor'], symbol: unit['Symbol'] }
    end

    @un_ece_21_units.each do |unit|
      code = 'X' + unit['Code']
      name = unit['Name']
      name[0] = name[0].downcase

      options[code] = { name: name, description: unit['Description'], baseUnit: nil, conversionFactor: nil, symbol: unit['Symbol'] }
    end

    options.each do |code, option|
      option[:translation_available] = !ArticleUnitsLib.get_translated_name_for_code(code, default_nil: true).nil?
    end

    @untranslated_units = options
  end

  def self.unit_translations
    return @unit_translations unless @unit_translations.nil?

    @unit_translations = YAML.safe_load(ERB.new(File.read(File.expand_path("config/units-of-measure/locales/unece_#{I18n.locale}.yml", Rails.root))).result) || {}
  end

  def self.units
    return @units unless @units.nil?

    units = self.untranslated_units
    @units = units.to_h do |code, unit|
      translated_name = ArticleUnitsLib.get_translated_name_for_code(code, default_nil: true)
      unit = unit.clone
      unit[:name] = translated_name || unit[:name]
      unit[:untranslated] = translated_name.nil?
      unit[:symbol] = ArticleUnitsLib.get_translated_symbol_for_code(code)
      unit[:aliases] = ArticleUnitsLib.get_translated_aliases_for_code(code)

      [code, unit]
    end
  end

  def self.unit_is_si_convertible(code)
    !units.to_h[code]&.dig(:conversionFactor).nil?
  end

  def self.get_translated_name_for_code(code, default_nil: false)
    return nil if code.blank?

    self.unit_translations&.dig('unece_units')&.dig(code)&.dig('name') || (default_nil ? nil : self.untranslated_units[code][:name])
  end

  def self.get_translated_symbol_for_code(code)
    return nil if code.blank?

    self.unit_translations&.dig('unece_units')&.dig(code)&.dig('symbols')&.dig(0) || self.untranslated_units[code][:symbol]
  end

  def self.get_translated_aliases_for_code(code)
    return nil if code.blank?

    self.unit_translations&.dig('unece_units')&.dig(code)&.dig('aliases')
  end

  def self.get_code_for_translated_name(name)
    # This is just a temporary sample to have the method
    # TODO: Proper unit translations - see https://github.com/foodcoopsat/foodsoft_hackathon/issues/10
    return nil if name.blank?

    code = 'XBO' if name == 'bottle'
    if code.nil?
      code = self.untranslated_units.select { |_code, unit| unit[:name] == name }.keys[0]
    end

    code
  end

  def self.convert_old_unit(old_compound_unit_str, unit_quantity)
    return nil if old_compound_unit_str.nil?

    md = old_compound_unit_str.match(/([0-9]*)x(.*)/)
    old_compound_unit_str = md[2] if !md.nil? && md[1].to_f == unit_quantity

    md = old_compound_unit_str.match(%r{^\s*([0-9][0-9,./]*)?\s*([A-Za-z\u00C0-\u017F.]+)\s*$})
    return nil if md.nil?

    unit = get_unit_from_old_str(md[2])
    return nil if unit.nil?

    quantity = get_quantity_from_old_str(md[1])

    if quantity == 1 && unit_quantity == 1
      {
        supplier_order_unit: unit,
        first_ratio: nil,
        group_order_granularity: 1.0,
        group_order_unit: unit
      }
    else
      supplier_order_unit = unit.starts_with?('X') && unit != 'XPK' ? 'XPK' : 'XPP'
      {
        supplier_order_unit: supplier_order_unit,
        first_ratio: {
          quantity: quantity * unit_quantity,
          unit: unit
        },
        group_order_granularity: unit_quantity > 1 ? quantity : 1.0,
        group_order_unit: unit_quantity > 1 ? unit : supplier_order_unit
      }
    end
  end

  def self.get_quantity_from_old_str(quantity_str)
    return 1 if quantity_str.nil?

    quantity_str = quantity_str
                   .gsub(',', '.')
                   .gsub(' ', '')

    division_parts = quantity_str.split('/').map(&:to_f)

    if division_parts.length == 2
      division_parts[0] / division_parts[1]
    else
      quantity_str.to_f
    end
  end

  def self.get_unit_from_old_str(old_unit_str)
    unit_str = old_unit_str.strip.downcase
    units = ArticleUnitsLib.untranslated_units
                           .sort { |a, b| sort_by_translation_state(a[1], b[1]) }
    matching_unit_arr = units.select { |key, unit| matches_unit(key, unit, unit_str) }
                             .to_a
    return nil if matching_unit_arr.empty?

    matching_unit_arr[0][0]
  end

  def self.sort_by_translation_state(unit_a, unit_b)
    return -1 if unit_a[:translation_available] && !unit_b[:translation_available]
    return 1 if unit_b[:translation_available] && !unit_a[:translation_available]

    0
  end

  def self.matches_unit(unit_code, unit, unit_str)
    return true if unit[:symbol] == unit_str

    translation_data = self.unit_translations&.dig('unece_units')&.dig(unit_code)

    return true if translation_data&.dig('symbols')&.include?(unit_str)

    name = translation_data&.dig('name')&.downcase
    return true if !name.nil? && name == unit_str

    aliases = translation_data&.dig('aliases')&.map(&:strip)
    !aliases.nil? && aliases.any? { |a| a == unit_str || "#{a}." == unit_str }
  end
end
