class AlterArticlesAddMoreUnitLogic < ActiveRecord::Migration[5.2]
  def up
    change_table :articles do |t|
      t.column :supplier_order_unit_un_ece, :string, length: 3
      t.column :price_unit_un_ece, :string, length: 3
      t.column :bill_unit_un_ece, :string, length: 3
      t.column :group_order_unit_un_ece, :string, length: 3
      t.column :group_order_granularity, :float
    end

    create_table :article_unit_conversions do |t|
      t.references :article, null: false

      t.column :sort, :integer, null: false
      t.column :amount, :float
      t.column :unit_un_ece, :string, length: 3
    end

    articles = select_all('SELECT id, unit_quantity FROM articles')
    articles.each do |article|
      update("INSERT INTO article_unit_conversions (article_id, sort, amount) VALUES (#{quote article['id']}, #{quote 1}, #{quote article['unit_quantity']})")
    end

    change_table :articles do |t|
      t.remove :unit_quantity
    end
  end

  def down
    change_table :articles do |t|
      t.remove :supplier_order_unit_un_ece
      t.remove :price_unit_un_ece
      t.remove :bill_unit_un_ece
      t.remove :group_order_unit_un_ece
      t.remove :group_order_granularity
      t.column :unit_quantity, :integer, null: false
    end

    article_unit_conversions = select_all('SELECT article_id, amount FROM article_unit_conversions WHERE sort=1')
    article_unit_conversions.each do |article_unit_conversion|
      update("UPDATE articles SET unit_quantity=#{quote article_unit_conversion['amount']} WHERE id=#{quote article_unit_conversion['article_id']}")
    end

    drop_table :article_unit_conversions
  end
end
