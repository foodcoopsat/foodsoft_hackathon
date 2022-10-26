class AlterArticlesAddVersioning < ActiveRecord::Migration[5.2]
  def up
    change_table :articles do |t|
      t.column :uuid, :string, length: 36, after: :id
      t.column :version, :integer, after: :uuid
    end

    article_prices = select_all('SELECT id, article_id, price, tax, deposit, unit_quantity, created_at FROM article_prices ORDER BY article_id ASC, id ASC')
    grouped_prices = article_prices.group_by { |article_price| article_price['article_id'] }
    grouped_prices.each do |article_id, article_prices_in_group|
      uuid = Digest::UUID.uuid_v4
      update("UPDATE articles SET uuid=#{quote uuid}, version=#{quote(article_prices_in_group.length - 1)} WHERE id = #{quote article_id}")
      article = select_one("SELECT name, supplier_id, article_category_id, unit, note, availability, manufacturer, origin, shared_updated_on, order_number, updated_at, type, quantity FROM articles WHERE id = #{quote article_id}")
      article_prices_in_group.each_with_index do |article_price, index|
        new_article_id = insert(%{
          INSERT INTO articles (
            uuid,
            version,
            name,
            supplier_id,
            article_category_id,
            unit,
            note,
            availability,
            manufacturer,
            origin,
            shared_updated_on,
            order_number,
            updated_at,
            type,
            quantity,
            price,
            tax,
            deposit,
            created_at,
            unit_quantity
          ) VALUES (
            #{quote uuid},
            #{quote(index + 1)},
            #{quote article['name']},
            #{quote article['supplier_id']},
            #{quote article['article_category_id']},
            #{quote article['unit']},
            #{quote article['note']},
            #{quote article['availability']},
            #{quote article['manufacturer']},
            #{quote article['origin']},
            #{quote article['shared_updated_on']},
            #{quote article['order_number']},
            #{quote article['updated_at']},
            #{quote article['type']},
            #{quote article['quantity']},
            #{quote article_price['price']},
            #{quote article_price['tax']},
            #{quote article_price['deposit']},
            #{quote article_price['created_at']},
            #{quote article_price['unit_quantity']}
          )
        })

        update("UPDATE order_articles SET article_id = #{quote new_article_id} WHERE article_price_id = #{quote article_price['id']}")
      end
    end

    drop_table :article_prices

    change_table :articles do |t|
      t.change :uuid, :string, length: 36, null: false
      t.change :version, :integer, null: false, default: 0
    end

    add_index :articles, [:uuid, :version], unique: true
    add_index :articles, :uuid
    add_index :articles, :version

    change_table :order_articles do |t|
      t.remove :article_price_id
    end
  end

  def down
    create_table :article_prices do |t|
      t.references :article, :null => false
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :tax, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :deposit, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.integer :unit_quantity
      t.datetime :created_at
    end

    change_table :order_articles do |t|
      t.references :article_price, null: true
    end

    articles = select_all("SELECT id, uuid, version, price, tax, deposit, unit_quantity, created_at FROM articles ORDER BY uuid ASC, version DESC")
    grouped_articles = articles.group_by { |article| article['uuid'] }
    grouped_articles.each do |_uuid, articles_in_version_group|
      next if articles_in_version_group.length < 2

      base_article = articles_in_version_group[0]
      earlier_article_versions = articles_in_version_group[1..]

      earlier_article_versions.each do |article|
        article_price_id = insert(%{
          INSERT INTO article_prices (
            article_id,
            price,
            tax,
            deposit,
            unit_quantity,
            created_at
          ) VALUES (
            #{quote base_article['id']},
            #{quote article['price']},
            #{quote article['tax']},
            #{quote article['deposit']},
            #{quote article['unit_quantity']},
            #{quote article['created_at']}
          )
        })

        update("UPDATE order_articles SET article_id = #{quote base_article['id']}, article_price_id = #{quote article_price_id} WHERE article_id = #{quote article['id']}")
      end

      delete("DELETE FROM articles WHERE uuid=#{quote base_article['uuid']} AND version < #{quote base_article['version']}")
    end

    remove_index :articles, [:uuid, :version]

    change_table :articles do |t|
      t.remove :uuid
      t.remove :version
    end
  end

  # We cannot use quote out of context (as it wouldn't relate to the current DB syntax),
  # but using Article's db connection by default should be fine
  def quote(value)
    Article.connection.quote(value)
  end
end
