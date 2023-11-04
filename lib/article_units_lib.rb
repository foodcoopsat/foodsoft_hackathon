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

    @untranslated_units = options
  end

  def self.units
    units = self.untranslated_units
    units.each do |code, unit|
      translated_name = ArticleUnitsLib.get_translated_name_for_code(code, default_nil: true)
      unit[:name] = translated_name || unit[:name]
      unit[:untranslated] = translated_name.nil?
      unit[:symbol] = ArticleUnitsLib.get_translated_symbol_for_code(code)
    end

    units
  end

  def self.get_translated_name_for_code(code, default_nil: false)
    return nil if code.blank?

    I18n.t "unece_units.#{code}.name", default: default_nil ? nil : self.untranslated_units[code][:name]
  end

  def self.get_translated_symbol_for_code(code)
    return nil if code.blank?

    I18n.t "unece_units.#{code}.symbol", default: self.untranslated_units[code][:symbol]
  end

  def self.get_code_for_translated_name(name)
    # This is just a temporary sample to have the method
    # TODO: Proper unit translations - see https://github.com/foodcoopsat/foodsoft_hackathon/issues/10
    return nil if name.blank?

    code = 'XBO' if name == 'bottle'
    if code.nil?
      code = self.untranslated_units.select { |_code, unit| unit[:visible] && unit[:name] == name }.keys[0]
    end

    code
  end
end
