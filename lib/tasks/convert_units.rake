namespace :units do
  task :convert do
    base_unit_entries = []

    un_ece_20_units = YAML.safe_load(ERB.new(File.read(File.expand_path('config/units-of-measure/un-ece-20.yml', Rails.root))).result)
    re = /^(?:([, 0-9]*)(?: x )!?)?([, 0-9⁰-⁹⁻¹²³]*)?(.*)?$/
    un_ece_20_units.each do |unit|
      md = unit['ConversionFactor'].match(re)
      multiplier = md[1]
      potency = md[2]
      base_unit = md[3]

      multiplier&.strip!
      potency&.strip!
      base_unit&.strip!

      if multiplier.blank? && (!potency.nil? && !/[⁰-⁹⁻¹²³]+/.match(potency))
        multiplier = potency
        potency = ''
      end

      multiplier&.gsub!(',', '.')
      multiplier&.gsub!(' ', '')
      multiplier = multiplier.blank? ? 1 : BigDecimal(multiplier)

      unit['conversion'] = {}
      unit['conversion']['unit'] = base_unit

      power_of_ten = potency.match(/^10 *?([⁰-⁹⁻¹²³]+)$/)&.[](1)
      power_of_ten = superscript_to_number(power_of_ten) unless power_of_ten.nil?

      base_unit_multiplier = multiplier
      base_unit_multiplier *= (10**power_of_ten) unless power_of_ten.nil?
      unit['conversion']['factor'] = base_unit_multiplier.to_s.to_f
      is_base_unit = !base_unit.blank? && potency.blank? && multiplier == 1

      base_unit_entries << unit if is_base_unit
    end

    un_ece_20_units.each do |unit|
      next if unit['conversion']['unit'].blank?

      base_units = base_unit_entries.select { |entry| entry['conversion']['unit'] == unit['conversion']['unit'] }
      unit['conversion']['base_units'] = base_units.map { |base_unit| base_unit['CommonCode'] }
    end

    un_ece_20_units.each do |unit|
      unit['conversion'].delete('unit')
    end

    File.write(File.expand_path('config/units-of-measure/un-ece-20-remastered.yml', Rails.root), un_ece_20_units.to_yaml)
  end
end

# I know this is stupid, but I couldn't find a default ruby/rails method for this and wouldn't be
# bothered to write a nicer unicode mapper for these few characters:
def superscript_to_number(str)
  superscript_hash = {
    '⁻' => '-', '⁰' => '0', '¹' => '1', '²' => '2', '³' => '3', '⁴' => '4', '⁵' => '5', '⁶' => '6', '⁷' => '7', '⁸' => '8', '⁹' => '9'
  }

  str = str.chars.map { |c| superscript_hash[c] }.join

  BigDecimal(str) unless str == ''
end
