# extend the BigDecimal class
class String
  # remove comma from decimal inputs
  def self.delocalized_decimal(string)
    if string.present? and string.is_a?(String)
      BigDecimal(string.sub(',', '.'))
    else
      string
    end
  end
end

class Array
  def cumulative_sum
    csum = 0
    map { |val| csum += val }
  end
end
