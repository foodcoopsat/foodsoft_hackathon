# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_221_204_112_447) do
  create_table 'articles', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
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

  create_table 'suppliers', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', force: :cascade do |t|
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
    t.string 'salt'
    t.index ['name'], name: 'index_suppliers_on_name', unique: true
  end
end
