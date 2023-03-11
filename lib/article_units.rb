class ArticleUnits
  @un_ece_20_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-20-remastered.yml', Rails.root))).result)
  @un_ece_21_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-21.yml', Rails.root))).result)

  @allowed_units = %w[GRM HGM KGM LTR MLT XPP XCB XBO XBH XGR XPA]

  def self.untranslated_units
    options = {}

    @un_ece_20_units.each do |unit|
      code = unit['CommonCode']
      base_unit = unit['conversion']['base_units'].nil? ? nil : unit['conversion']['base_units'][0]
      options[code] = { name: unit['Name'], baseUnit: base_unit, conversionFactor: unit['conversion']['factor'], sign: unit['Symbol'], visible: @allowed_units.include?(code) }
    end

    @un_ece_21_units.each do |unit|
      code = 'X' + unit['Code']
      name = unit['Name']
      name[0] = name[0].downcase

      options[code] = { name: name, baseUnit: nil, conversionFactor: nil, sign: unit['Symbol'], visible: @allowed_units.include?(code) }
    end

    options
  end

  def self.units
    units = self.untranslated_units
    units.each do |code, unit|
      next unless @allowed_units.include?(code)

      unit[:name] = ArticleUnits.get_translated_name_for_code(code)
    end

    units
  end

  def self.get_translated_name_for_code(code)
    # This is just a temporary sample to have the method
    # TODO: Proper unit translations - see https://github.com/foodcoopsat/foodsoft_hackathon/issues/10
    return nil if code.blank?

    name = 'bottle' if code == 'XBO'
    if name.nil?
      name = self.untranslated_units[code][:name]
    end
    name
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

  def self.as_options
    options = {}

    self.units.each do |code, unit|
      next unless unit[:visible]

      options[unit[:name]] = code
    end

    options
  end
end
