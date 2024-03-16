class CreateArticlesAndSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table 'articles', force: :cascade do |t|
      t.string 'name', null: false
      t.integer 'supplier_id', null: false
      t.string 'number'
      t.string 'note'
      t.string 'manufacturer'
      t.string 'origin'
      t.string 'unit'
      t.decimal 'price', precision: 8, scale: 2, default: '0.0', null: false
      t.decimal 'tax', precision: 3, scale: 1, default: '7.0', null: false
      t.decimal 'deposit', precision: 8, scale: 2, default: '0.0', null: false
      t.decimal 'unit_quantity', precision: 4, scale: 1, default: '1.0', null: false
      t.decimal 'scale_quantity', precision: 4, scale: 2
      t.decimal 'scale_price', precision: 8, scale: 2
      t.datetime 'created_on'
      t.datetime 'updated_on'
      t.string 'category'
      t.index ['name'], name: 'index_articles_on_name'
      t.index %w[number supplier_id], name: 'index_articles_on_number_and_supplier_id', unique: true
    end

    create_table 'suppliers', force: :cascade do |t|
      t.string 'name', null: false
      t.string 'address', null: false
      t.string 'phone', null: false
      t.string 'phone2'
      t.string 'fax'
      t.string 'email'
      t.string 'url'
      t.string 'delivery_days'
      t.string 'note'
      t.datetime 'created_on'
      t.datetime 'updated_on'
      t.boolean 'ftp_sync', default: false
      t.string 'ftp_host'
      t.string 'ftp_user'
      t.string 'ftp_password'
      t.string 'ftp_type', default: 'bnn', null: false
      t.string 'ftp_regexp', default: '^([.]/)?PL'
      t.boolean 'mail_sync'
      t.string 'mail_from'
      t.string 'mail_subject'
      t.string 'mail_type'
      t.string 'salt', null: true
      t.index ['name'], name: 'index_suppliers_on_name', unique: true
    end
  end
end
