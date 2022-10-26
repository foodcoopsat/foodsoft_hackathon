class AlterArticlesAddMoreUnitLogic < ActiveRecord::Migration[5.2]
  def up
    change_table :articles do |t|
      t.column :supplier_order_unit, :string, length: 3
      t.column :price_unit, :string, length: 3
      t.column :billing_unit, :string, length: 3
      t.column :group_order_unit, :string, length: 3
      t.column :group_order_granularity, :decimal, precision: 8, scale: 3, null: false, default: 1
      t.column :minimum_order_quantity, :float
      t.change :unit, :string, null: true, default: nil
    end

    create_table :article_unit_ratios do |t|
      t.references :article, null: true

      t.column :sort, :integer, null: false, index: true
      t.column :quantity, :decimal, precision: 8, scale: 3, null: false
      t.column :unit, :string, length: 3
    end

    articles = select_all('SELECT id, unit_quantity FROM articles')
    articles.each do |article|
      insert("INSERT INTO article_unit_ratios (article_id, sort, quantity, unit) VALUES (#{quote article['id']}, #{quote 1}, #{quote article['unit_quantity']}, #{quote 'XPP'})")
    end

    change_table :articles do |t|
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

    article_unit_ratios = select_all('SELECT article_id, quantity FROM article_unit_ratios WHERE sort=1')
    article_unit_ratios.each do |article_unit_ratio|
      update("UPDATE articles SET unit_quantity=#{quote article_unit_ratio['quantity']} WHERE id=#{quote article_unit_ratio['article_id']}")
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
end
