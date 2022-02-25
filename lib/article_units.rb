class ArticleUnits
  @units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/units-of-measure.yml', Rails.root))).result)

  def self.as_options
    options = {}
    allowed_units = %w[GRM KGM]
    @units.select { |unit| allowed_units.include?(unit['CommonCode']) }.each do |unit|
      options[unit['Name']] = unit['CommonCode']
    end

    options['Piece'] = 'XPP'

    options
  end
end
