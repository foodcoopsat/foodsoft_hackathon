class ArticleUnits
  @un_ece_20_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-20-remastered.yml', Rails.root))).result)
  @un_ece_21_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-21.yml', Rails.root))).result)

  @allowed_units = %w[GRM HGM KGM LTR XPP XCB XBO XBH XGR]

  def self.units
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

      # name remappings -> TODO: make these configurable through the admin interface or something:
      name = 'bottle' if unit['Code'] == 'BO'
      options[code] = { name: name, baseUnit: nil, conversionFactor: nil, sign: unit['Symbol'], visible: @allowed_units.include?(code) }
    end

    options
  end

  def self.as_options
    options = {}

    # Allowed units -> TODO: make these configurable through the admin interface:
    @un_ece_20_units.select { |unit| @allowed_units.include?(unit['CommonCode']) }.each do |unit|
      name = unit['Name']

      options[name] = unit['CommonCode']
    end

    @un_ece_21_units.select { |unit| @allowed_units.include?('X' + unit['Code']) }.each do |unit|
      name = unit['Name']

      name[0] = name[0].downcase

      # name remappings -> TODO: make these configurable through the admin interface:
      name = 'bottle' if unit['Code'] == 'BO'

      options[name] = 'X' + unit['Code']
    end

    options
  end
end
