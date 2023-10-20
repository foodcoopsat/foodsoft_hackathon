class AlterArticlesAddMoreUnitLogic < ActiveRecord::Migration[5.2]
  def up
    change_table :article_versions do |t|
      t.column :supplier_order_unit, :string, length: 3
      t.column :price_unit, :string, length: 3
      t.column :billing_unit, :string, length: 3
      t.column :group_order_unit, :string, length: 3
      t.column :group_order_granularity, :decimal, precision: 8, scale: 3, null: false, default: 1
      t.column :minimum_order_quantity, :float
      t.change :unit, :string, null: true, default: nil
    end

    create_table :article_unit_ratios do |t|
      t.references :article_version, null: false

      t.column :sort, :integer, null: false, index: true
      t.column :quantity, :decimal, precision: 8, scale: 3, null: false
      t.column :unit, :string, length: 3
    end

    latest_article_versions = select_all(%{
      SELECT article_versions.*
      FROM article_versions
      JOIN (
        SELECT article_id, MAX(created_at) AS max_created_at
        FROM article_versions
        GROUP BY article_id
      ) AS latest_article_versions
      ON latest_article_versions.article_id = article_versions.article_id
        AND latest_article_versions.max_created_at = article_versions.created_at
    })
    latest_article_versions.each do |latest_article_version|
      unit_quantity = latest_article_version['unit_quantity'].nil? ? 1.0 : latest_article_version['unit_quantity'].to_f
      new_unit_data = convert_old_unit(latest_article_version['unit'], unit_quantity)
      next if new_unit_data.nil?

      new_version_id = insert(%{
        INSERT INTO article_versions (
          article_id, price, tax, deposit, created_at, name, article_category_id, note, availability, manufacturer, origin, order_number, updated_at, supplier_order_unit, group_order_granularity, group_order_unit, billing_unit, price_unit)
        VALUES(
          #{quote latest_article_version['article_id']},
          #{quote latest_article_version['price'].to_f * unit_quantity},
          #{quote latest_article_version['tax']},
          #{quote latest_article_version['deposit']},
          NOW(),
          #{quote latest_article_version['name']},
          #{quote latest_article_version['article_category_id']},
          #{quote latest_article_version['note']},
          #{quote latest_article_version['availability']},
          #{quote latest_article_version['manufacturer']},
          #{quote latest_article_version['origin']},
          #{quote latest_article_version['order_number']},
          NOW(),
          #{quote new_unit_data[:supplier_order_unit]},
          #{quote new_unit_data[:group_order_granularity]},
          #{quote new_unit_data[:group_order_unit]},
          #{quote new_unit_data[:supplier_order_unit]},
          #{quote new_unit_data[:supplier_order_unit]}
        )
      })

      next if new_unit_data[:first_ratio].nil?

      insert(%{
        INSERT INTO article_unit_ratios (article_version_id, sort, quantity, unit)
        VALUES (
          #{quote new_version_id},
          #{quote 1},
          #{quote new_unit_data[:first_ratio][:quantity]},
          #{quote new_unit_data[:first_ratio][:unit]}
        )
      })
    end

    article_versions = select_all('SELECT id, unit, unit_quantity, price FROM article_versions WHERE unit_quantity > 1 AND NOT unit IS NULL')
    article_versions.each do |article_version|
      insert(%{
        INSERT INTO article_unit_ratios (article_version_id, sort, quantity, unit)
        VALUES (
          #{quote article_version['id']},
          #{quote 1},
          #{quote article_version['unit_quantity']},
          #{quote 'XPP'}
        )
      })

      compound_unit = "#{article_version['unit_quantity']}x#{article_version['unit']}"
      update(%{
        UPDATE article_versions
        SET unit = #{quote compound_unit},
          group_order_granularity = #{quote 1},
          group_order_unit = #{quote 'XPP'},
          price = #{quote article_version['price'].to_f * article_version['unit_quantity']},
          price_unit = #{quote 'XPP'}
        WHERE article_versions.id = #{quote article_version['id']}
      })
    end

    change_table :article_versions do |t|
      t.remove :unit_quantity
    end

    change_table :order_articles do |t|
      t.change :quantity, :decimal, precision: 8, scale: 3, null: false
      t.change :tolerance, :decimal, precision: 8, scale: 3, null: false
    end

    change_table :group_order_articles do |t|
      t.change :quantity, :decimal, precision: 8, scale: 3, null: false
      t.change :tolerance, :decimal, precision: 8, scale: 3, null: false
    end

    change_table :group_order_article_quantities do |t|
      t.change :quantity, :decimal, precision: 8, scale: 3, null: false
      t.change :tolerance, :decimal, precision: 8, scale: 3, null: false
    end
  end

  def down
    change_table :article_versions do |t|
      t.remove :supplier_order_unit
      t.remove :price_unit
      t.remove :billing_unit
      t.remove :group_order_unit
      t.remove :group_order_granularity
      t.remove :minimum_order_quantity
      t.column :unit_quantity, :integer, null: false
      t.change :unit, :string, null: true, default: ''
    end

    article_unit_ratios = select_all('SELECT article_version_id, quantity FROM article_unit_ratios WHERE sort=1')
    article_unit_ratios.each do |article_unit_ratio|
      update(%{
        UPDATE article_versions
        SET unit_quantity = #{quote article_unit_ratio['quantity']}
        WHERE id = #{quote article_unit_ratio['article_version_id']}
      })
    end

    drop_table :article_unit_ratios

    change_table :order_articles do |t|
      t.change :quantity, :integer, null: false
      t.change :tolerance, :integer, null: false
    end

    change_table :group_order_articles do |t|
      t.change :quantity, :integer, null: false
      t.change :tolerance, :integer, null: false
    end

    change_table :group_order_article_quantities do |t|
      t.change :quantity, :integer, null: false
      t.change :tolerance, :integer, null: false
    end
  end

  private

  def convert_old_unit(old_compound_unit_str, unit_quantity)
    md = old_compound_unit_str.match(%r{^\s*([0-9][0-9,./]*)?\s*([A-Za-z\u00C0-\u017F]+)\s*$})
    return nil if md.nil?

    unit = get_unit_from_old_str(md[2])
    return nil if unit.nil?

    quantity = get_quantity_from_old_str(md[1])

    if quantity == 1
      {
        supplier_order_unit: unit,
        first_ratio: nil,
        group_order_granularity: 1.0,
        group_order_unit: unit
      }
    else
      supplier_order_unit = unit == 'XPP' ? 'XPA' : 'XPP'
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

  def get_quantity_from_old_str(quantity_str)
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

  def get_unit_from_old_str(old_unit_str)
    unit_str = old_unit_str.strip.downcase
    matching_unit_arr = ArticleUnits.untranslated_units
                                    .select { |_key, unit| unit[:visible] && (unit[:sign] == unit_str || matches_unit_name(unit, unit_str)) }
                                    .to_a
    return nil if matching_unit_arr.empty?

    matching_unit_arr[0][0]
  end

  # Temporary workaround to
  # a. map single names to unit specs' name fields (which include multiple names separated by commas)
  # b. include some German unit names
  # TODO: Do unit translations and matching properly somehow
  # see https://github.com/foodcoopsat/foodsoft_hackathon/issues/10
  def matches_unit_name(unit, unit_str)
    unit_str = case unit_str
               when "bund"
                 "bunch"
               when "stück", "stk"
                 "piece"
               when "glas", "gl"
                 "glass"
               when "pkg", "packung"
                 "packet"
               else
                 unit_str
               end

    name = unit[:name].downcase
    return true if name == unit_str

    name.split(',').map(&:strip).include?(unit_str)
  end
end
