require_relative 'seed_helper'

## Financial transaction classes

FinancialTransactionClass.create!(id: 1, name: 'Standard')
FinancialTransactionClass.create!(id: 2, name: 'Foodsoft')

## Article units

unit_codes = ArticleUnitsLib::DEFAULT_PIECE_UNIT_CODES + ArticleUnitsLib::DEFAULT_METRIC_SCALAR_UNIT_CODES
unit_codes.each { |unit_code| ArticleUnit.create!(unit: unit_code) }

## Suppliers & articles

SupplierCategory.create!(id: 1, name: 'Other', financial_transaction_class_id: 1)

Supplier.create!([
                   { id: 1, name: 'Hackathon', supplier_category_id: 1, address: 'Smallstreet 1, Cookilage',
                     phone: '0123456789', email: 'info@bbakery.test', min_order_quantity: '100', unit_migration_completed: Time.now }
                 ])

ArticleCategory.create!(id: 1, name: 'Sonstiges')
ArticleCategory.create!(id: 2, name: 'Obst')
ArticleCategory.create!(id: 3, name: 'Gemüse')
ArticleCategory.create!(id: 4, name: 'Kartoffel & Zwiebel')
ArticleCategory.create!(id: 5, name: 'Backwaren')
ArticleCategory.create!(id: 6, name: 'Getränke')
ArticleCategory.create!(id: 7, name: 'Kräuter & Gewürze')
ArticleCategory.create!(id: 8, name: 'Mich & Milchprodukte')
ArticleCategory.create!(id: 9, name: 'Fisch & Meeresfrüchte')
ArticleCategory.create!(id: 10, name: 'Fleisch')
ArticleCategory.create!(id: 11, name: 'Öle & Fett')
ArticleCategory.create!(id: 12, name: 'Getreide & Bohnen')
ArticleCategory.create!(id: 13, name: 'Nüsse & Samen')
ArticleCategory.create!(id: 14, name: 'Zucker & Süßigkeiten')

Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Karotten', article_category_id: 3, unit: nil, price: 3, tax: 7.0,
                                                           deposit: '0.0', supplier_order_unit: 'KGM', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.001 })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Kürbis', article_category_id: 3, unit: nil, price: 1.5, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'XPP',
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 1.3, unit: 'KGM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Brot', article_category_id: 5, unit: nil, price: 2.1, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'XPP', group_order_granularity: 0.5,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 700, unit: 'GRM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Semmeln', article_category_id: 5, unit: nil, price: 1, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'XPP', group_order_unit: 'XPP', minimum_order_quantity: 5,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 350, unit: 'GRM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Müsli', article_category_id: 13, unit: nil, price: 2.5, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'XPP', billing_unit: 'XPP', group_order_unit: 'XPP',
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 500, unit: 'GRM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Räuchertofu', article_category_id: 8, unit: nil, price: 2.4, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'HGM', billing_unit: 'GRM', group_order_unit: 'XPP',
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 160, unit: 'GRM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Bier', article_category_id: 6, unit: nil, price: 52, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XCR', price_unit: 'XBO', billing_unit: 'XBO', group_order_unit: 'XBO',
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 20, unit: 'XBO' }), ArticleUnitRatio.new({ sort: 2, quantity: 10, unit: 'LTR' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Waschmittel', article_category_id: 1, unit: nil, price: 20, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'LTR', billing_unit: 'LTR', group_order_unit: 'LTR', group_order_granularity: 0.001,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 2, quantity: 20, unit: 'LTR' }), ArticleUnitRatio.new({ sort: 2, quantity: 25, unit: 'KGM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Reis', article_category_id: 12, unit: nil, price: 6.75, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.05,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 25, unit: 'KGM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Kartoffeln', article_category_id: 3, unit: nil, price: 1.5, tax: 7.0,
                                                           deposit: '0.0', supplier_order_unit: 'KGM', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'GRM' })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Weizen', article_category_id: 12, unit: nil, price: 25, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.05,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 25, unit: 'KGM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Orangen', article_category_id: 2, unit: nil, price: 36, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.05,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 12, unit: 'KGM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Linsen', article_category_id: 12, unit: nil, price: 2.7, tax: 7.0, deposit: '0.0', supplier_order_unit: 'XPP', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.05,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 500, unit: 'GRM' })] })
Article.create!({ supplier_id: 1,
                  quantity: 0 }).article_versions.create({ name: 'Austernpilze', article_category_id: 3, unit: nil,
                                                           price: 3, tax: 7.0, deposit: '0.0', supplier_order_unit: 'KGM', price_unit: 'KGM', billing_unit: 'KGM', group_order_unit: 'KGM', group_order_granularity: 0.001, minimum_order_quantity: 1.2 })

Supplier.create!([
                   { id: 2, name: 'Einheiten-Migrations-Test', supplier_category_id: 1,
                     address: 'Smallstreet 2, Cookilage', phone: '0123456789', email: 'info@bbakery.test', min_order_quantity: '100', unit_migration_completed: nil }
                 ])

Article.create!({ supplier_id: 2,
                  quantity: 0 }).article_versions.create({ name: 'Ziegenkäse', article_category_id: 8, unit: '250g', price: 3, tax: 7.0,
                                                           deposit: '0.0', supplier_order_unit: nil, price_unit: nil, billing_unit: nil, group_order_unit: nil, group_order_granularity: 1 })
Article.create!({ supplier_id: 2,
                  quantity: 0 }).article_versions.create({ name: 'Butter', article_category_id: 8, unit: '4x250g', price: 3, tax: 7.0, deposit: '0.0', supplier_order_unit: nil, price_unit: 'XPP', billing_unit: 'XPP', group_order_unit: 'XPP', group_order_granularity: 1,
                                                           article_unit_ratios: [ArticleUnitRatio.new({ sort: 1, quantity: 4, unit: 'XPP' })] })
Article.create!({ supplier_id: 2,
                  quantity: 0 }).article_versions.create({ name: 'Brot', article_category_id: 5, unit: 'Stk', price: 3, tax: 7.0,
                                                           deposit: '0.0', supplier_order_unit: nil, price_unit: nil, billing_unit: nil, group_order_unit: nil, group_order_granularity: 1 })

## Members & groups

User.create!(id: 1, nick: 'admin', password: 'secret', first_name: 'Anton', last_name: 'Administrator',
             email: 'admin@foo.test', created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00')
User.create!(id: 2, nick: 'john', password: 'secret', first_name: 'John', last_name: 'Doe', email: 'john@doe.test',
             created_on: 'Sun, 19 Jan 2014 17:38:22 UTC +00:00')
User.create!(id: 3, nick: 'peter', password: 'secret', first_name: 'Peter', last_name: 'Peters',
             email: 'peter@peters.test', created_on: 'Sat, 25 Jan 2014 20:20:36 UTC +00:00')
User.create!(id: 4, nick: 'jan', password: 'secret', first_name: 'Jan', last_name: 'Lou', email: 'jan@lou.test',
             created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00')
User.create!(id: 5, nick: 'mary', password: 'secret', first_name: 'Mary', last_name: 'Lou', email: 'marie@lou.test',
             created_on: 'Mon, 03 Feb 2014 11:47:17 UTC +00:00')
User.find(1).settings['profile'] = { language: :de }

Workgroup.create!(id: 1, name: 'Administrators', description: 'System administrators.', account_balance: 0.0, created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00', role_admin: true, role_suppliers: true, role_article_meta: true, role_finance: true, role_orders: true,
                  next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 2, name: 'Finances', account_balance: 0.0, created_on: 'Sun, 19 Jan 2014 17:40:03 UTC +00:00',
                  role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: true, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 3, name: 'Ordering', account_balance: 0.0, created_on: 'Thu, 20 Feb 2014 14:44:47 UTC +00:00',
                  role_admin: false, role_suppliers: false, role_article_meta: true, role_finance: false, role_orders: true, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 4, name: 'Assortment', account_balance: 0.0, created_on: 'Wed, 09 Apr 2014 12:24:55 UTC +00:00',
                  role_admin: false, role_suppliers: true, role_article_meta: true, role_finance: false, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 5, name: 'Admin Administrator', account_balance: 0.0, created_on: 'Sat, 18 Jan 2014 00:38:48 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, stats: { jobs_size: 0, orders_sum: 1021.74 },
                   next_weekly_tasks_number: 8, ignore_apple_restriction: true)
Ordergroup.create!(id: 6, name: "Pete's house", account_balance: -0.35E2, created_on: 'Sat, 25 Jan 2014 20:20:37 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'Piet Pieterssen',
                   stats: { jobs_size: 0, orders_sum: 60.96 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 7, name: 'Jan Klaassen', account_balance: -0.35E2, created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'Jan Klaassen',
                   stats: { jobs_size: 0, orders_sum: 0 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 8, name: 'John Doe', account_balance: 0.90E2, created_on: 'Wed, 09 Apr 2014 12:23:29 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'John Doe',
                   stats: { jobs_size: 0, orders_sum: 0 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)

Membership.create!(group_id: 1, user_id: 1)
Membership.create!(group_id: 5, user_id: 1)
Membership.create!(group_id: 2, user_id: 2)
Membership.create!(group_id: 8, user_id: 2)
Membership.create!(group_id: 6, user_id: 3)
Membership.create!(group_id: 7, user_id: 4)
Membership.create!(group_id: 8, user_id: 4)
Membership.create!(group_id: 3, user_id: 4)
Membership.create!(group_id: 7, user_id: 5)
Membership.create!(group_id: 3, user_id: 5)
Membership.create!(group_id: 4, user_id: 5)

## Orders & OrderArticles

seed_order(supplier_id: 1, starts: 2.days.ago, ends: 5.days.from_now)

## Finances

FinancialTransactionType.create!(id: 1, name: 'Foodcoop', financial_transaction_class_id: 1)

FinancialTransaction.create!(id: 1, ordergroup_id: 5, amount: -0.35E2, note: 'Membership fee for ordergroup',
                             user_id: 1, created_on: 'Sat, 18 Jan 2014 00:38:48 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 3, ordergroup_id: 6, amount: -0.35E2, note: 'Membership fee for ordergroup',
                             user_id: 1, created_on: 'Sat, 25 Jan 2014 20:20:37 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 4, ordergroup_id: 7, amount: -0.35E2, note: 'Membership fee for ordergroup',
                             user_id: 1, created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 5, ordergroup_id: 5, amount: 0.35E2, note: 'payment', user_id: 2,
                             created_on: 'Wed, 05 Feb 2014 16:49:24 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 6, ordergroup_id: 8, amount: 0.90E2, note: 'Bank transfer', user_id: 2,
                             created_on: 'Mon, 17 Feb 2014 16:19:34 UTC +00:00', financial_transaction_type_id: 1)

FoodsoftConfig[:minimum_balance] = '-10000'
