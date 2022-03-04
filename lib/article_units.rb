class ArticleUnits
  @un_ece_20_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-20.yml', Rails.root))).result)
  @un_ece_21_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-21.yml', Rails.root))).result)

  def self.as_options
    options = {}

    # Allowed units -> TODO: make these configurable through the admin interface:
    allowed_units = %w[GRM KGM LTR XPP XCB XBO]

    @un_ece_20_units.select { |unit| allowed_units.include?(unit['CommonCode']) }.each do |unit|
      name = unit['Name']

      options[name] = unit['CommonCode']
    end

    @un_ece_21_units.select { |unit| allowed_units.include?('X' + unit['Code']) }.each do |unit|
      name = unit['Name']

      name[0] = name[0].downcase

      # name remappings -> TODO: make these configurable through the admin interface:
      name = 'bottle' if unit['Code'] == 'BO'

      options[name] = 'X' + unit['Code']
    end

    options
  end
end
