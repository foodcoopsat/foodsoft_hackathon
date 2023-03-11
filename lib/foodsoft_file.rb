# Foodsoft-file import
class FoodsoftFile
  # parses a string from a foodsoft-file
  # returns two arrays with articles and outlisted_articles
  # the parsed article is a simple hash
  def self.parse(file, options = {})
    SpreadsheetFile.parse file, options do |row, row_index|
      next if row[2].blank?

      article = { :order_number => row[1],
                  :name => row[2],
                  :note => row[3],
                  :manufacturer => row[4],
                  :origin => row[5],
                  :unit => row[6],
                  :price => row[7],
                  :tax => row[8],
                  :deposit => (row[9].nil? ? "0" : row[9]),
                  # :quantity => row[10], TODO?
                  :supplier_order_unit => ArticleUnits.get_code_for_translated_name(row[11]),
                  :price_unit => ArticleUnits.get_code_for_translated_name(row[12]),
                  :group_order_unit => ArticleUnits.get_code_for_translated_name(row[13]),
                  :group_order_granularity => row[14],
                  :minimum_order_quantity => row[15],
                  :article_category => row[18],
                  :article_unit_ratios => FoodsoftFile.parse_ratios_cell(row[19]) }
      status = row[0] && row[0].strip.downcase == 'x' ? :outlisted : nil
      yield status, article, row_index
    end
  end

  def self.parse_ratios_cell(ratios_cell)
    return [] if ratios_cell.blank?

    ratios_cell.split(', ').each_with_index.map do |ratio_str, index|
      md = ratio_str.match(/(?<quantity>[+-]?(?:[0-9]*[.])?[0-9]+) (?<unit_name>.*)/)
      {
        sort: index + 1,
        quantity: md[:quantity],
        unit: ArticleUnits.get_code_for_translated_name(md[:unit_name])
      }
    end
  end
end
