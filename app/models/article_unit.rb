class ArticleUnit < ApplicationRecord
  self.primary_key = :unit

  def self.all_cached
    return @all_cached unless @all_cached.nil?

    @all_cached = all.load
  end

  def self.clear_cache
    @all_cached = nil
  end

  def self.as_hash
    available_units = all_cached.map(&:unit)
    ArticleUnitsLib.units.to_h { |code, unit| [code, unit.merge({ visible: available_units.include?(code) })] }
  end

  def self.as_options(config)
    additional_units = config&.dig(:additional_units) || []
    options = {}

    available_units = all_cached.map(&:unit)
    ArticleUnitsLib.units.each do |code, unit|
      next unless available_units.include?(code) || additional_units.include?(code)

      options[unit[:name]] = code
    end

    options
  end
end
