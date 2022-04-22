class AlterArticlesAddMoreUnitLogic < ActiveRecord::Migration[5.2]
  def up
    change_table :articles do |t|
      t.column :supplier_order_unit, :string, length: 3
      t.column :price_unit, :string, length: 3
      t.column :billing_unit, :string, length: 3
      t.column :group_order_unit, :string, length: 3
      t.column :group_order_granularity, :float, null: false, default: 1
      t.column :minimum_order_quantity, :float
      t.change :unit, :string, null: true, default: nil
    end

    change_table :article_prices do |t|
      t.column :supplier_order_unit, :string, length: 3
      t.column :price_unit, :string, length: 3
      t.column :billing_unit, :string, length: 3
      t.column :group_order_unit, :string, length: 3
      t.column :group_order_granularity, :float, null: false, default: 1
      t.column :minimum_order_quantity, :float
    end

    create_table :article_unit_ratios do |t|
      t.references :article, null: true
      t.references :article_price, null: true

      t.column :sort, :integer, null: false, index: true
      t.column :quantity, :float, null: false
      t.column :unit, :string, length: 3
    end

    articles = select_all('SELECT id, unit_quantity FROM articles')
    articles.each do |article|
      update("INSERT INTO article_unit_ratios (article_id, sort, quantity, unit) VALUES (#{quote article['id']}, #{quote 1}, #{quote article['unit_quantity']}, #{quote 'XPP'})")
    end

    article_prices = select_all('SELECT id, unit_quantity FROM article_prices')
    article_prices.each do |article_price|
      update("INSERT INTO article_unit_ratios (article_price_id, sort, quantity, unit) VALUES (#{quote article_price['id']}, #{quote 1}, #{quote article_price['unit_quantity']}, #{quote 'XPP'})")
    end

    change_table :articles do |t|
      t.remove :unit_quantity
    end

    change_table :article_prices do |t|
      t.remove :unit_quantity
    end
  end

  def down
    change_table :articles do |t|
      t.remove :supplier_order_unit
      t.remove :price_unit
      t.remove :billing_unit
      t.remove :group_order_unit
      t.remove :group_order_granularity
      t.remove :minimum_order_quantity
      t.column :unit_quantity, :integer, null: false
      t.change :unit, :string, null: true, default: ''
    end

    change_table :article_prices do |t|
      t.remove :supplier_order_unit
      t.remove :price_unit
      t.remove :billing_unit
      t.remove :group_order_unit
      t.remove :group_order_granularity
      t.remove :minimum_order_quantity
      t.column :unit_quantity, :integer, null: false
    end

    article_unit_ratios = select_all('SELECT article_id, quantity FROM article_unit_ratios WHERE sort=1')
    article_unit_ratios.each do |article_unit_ratio|
      if article_unit_ratio['article_id'].nil?
        update("UPDATE article_prices SET unit_quantity=#{quote article_unit_ratio['quantity']} WHERE id=#{quote article_unit_ratio['article_price_id']}")
      else
        update("UPDATE articles SET unit_quantity=#{quote article_unit_ratio['quantity']} WHERE id=#{quote article_unit_ratio['article_id']}")
      end
    end

    drop_table :article_unit_ratios
  end
end
