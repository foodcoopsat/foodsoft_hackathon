require_relative 'seed_helper'

## Financial transaction classes

FinancialTransactionClass.create!(id: 1, name: 'Standard')
FinancialTransactionClass.create!(id: 2, name: 'Foodsoft')

## Suppliers & articles

SupplierCategory.create!(id: 1, name: 'Other', financial_transaction_class_id: 1)

Supplier.create!([
                   { id: 1, name: 'Beautiful bakery', supplier_category_id: 1,
                     address: 'Smallstreet 1, Cookilage', phone: '0123456789', email: 'info@bbakery.test', min_order_quantity: '100' },
                   { id: 2, name: 'Chocolatiers', supplier_category_id: 1,
                     address: 'Multatuliroad 1, Amsterdam', phone: '0123456789', email: 'info@chocolatiers.test', url: 'http://www.chocolatiers.test/', contact_person: 'Max Pure', delivery_days: 'Tue, Fr (Amsterdam)' },
                   { id: 3, name: 'Cheesemaker', supplier_category_id: 1,
                     address: 'Cheesestreet 5, London', phone: '0123456789', url: 'http://www.cheesemaker.test/' },
                   { id: 4, name: 'The Nuthome', supplier_category_id: 1,
                     address: 'Alexanderplatz, Berlin', phone: '0123456789', email: 'info@thenuthome.test', url: 'http://www.thenuthome.test/', note: 'delivery in Berlin; €9 delivery costs for orders under €123' }
                 ])

ArticleCategory.create!(id: 1, name: 'Other', description: 'other, misc, unknown')
ArticleCategory.create!(id: 2, name: 'Fruit')
ArticleCategory.create!(id: 3, name: 'Vegetables')
ArticleCategory.create!(id: 4, name: 'Potatoes & onions')
ArticleCategory.create!(id: 5, name: 'Bread & Bakery')
ArticleCategory.create!(id: 6, name: 'Drinks', description: 'juice, fruit juice, vegetable juice, soda')
ArticleCategory.create!(id: 7, name: 'Herbs & Spices')
ArticleCategory.create!(id: 8, name: 'Milk & products',
                        description: 'milk, butter, cream, yoghurt, cheese, eggs, milk substitutes')
ArticleCategory.create!(id: 9, name: 'Fish & Sea')
ArticleCategory.create!(id: 10, name: 'Meat')
ArticleCategory.create!(id: 11, name: 'Oils & Fats')
ArticleCategory.create!(id: 12, name: 'Grains & Legumes')
ArticleCategory.create!(id: 13, name: 'Nuts & Seeds')
ArticleCategory.create!(id: 14, name: 'Sugar & Sweets')

Article.create!(name: 'Brown whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brown half', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brown sesame whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brown sesame half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Light wheat whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Light wheat half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bread with sunflower seeds whole', supplier_id: 1, article_category_id: 5,
                unit: 'pc', note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bread with sunflower seeds  half', supplier_id: 1, article_category_id: 5,
                unit: 'pc', note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bread with walnuts whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bread with walnuts half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kennemerlandbread whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kennemerlandbread half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Maize bread whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Maize bread  half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 1200 gram whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 1200 gram half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 900 gram whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 900 gram half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Speltbread whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Speltbread half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Country bread 900gram whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Country bread 900gram half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'White  whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'White  half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'White with poppy seeds whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'White with poppy seeds half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Fig bread whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Fig bread half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Beer-based bread whole', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Beer-based bread half', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Raisin bun', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.99E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Muesli bun', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brioche', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.99E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brown croissant', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Croissants', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Cheese croissants', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolatecroissants', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Soepstengels white', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Soepstengels volkoren', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.99E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Pumpkin-seed buns', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.88E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'White buns', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.66E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brown buns', supplier_id: 1, article_category_id: 5, unit: 'pc', note: 'organic',
                availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.66E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Tomato-feta bread', supplier_id: 1, article_category_id: 5, unit: 'pc',
                note: 'organic', availability: true, manufacturer: 'The Baker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolate Bar Milk (37%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolate Bar Pure (68%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolate Bar Milk (40%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolate Bar Pure (75%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocolate Bar Swan Pure (75%)', supplier_id: 2, article_category_id: 14,
                unit: '120gr', note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.66E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Cacao nibs', supplier_id: 2, article_category_id: 14, unit: '1 kg',
                note: 'organic', availability: true, manufacturer: 'Chocolatemakers', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Cheese Cow-young', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.88E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- young matured', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- matured', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 12)
Article.create!(name: 'Cheese cow- extra matured', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.12E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'cheese Cow- old', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'cheese cow -very old', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.12E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese Cow-nettle young', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- nettle young matured', supplier_id: 3, article_category_id: 8,
                unit: 'kg', note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.1075E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- nettle matured', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese Cow-cumin young', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- cumin young matured', supplier_id: 3, article_category_id: 8,
                unit: 'kg', note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.1075E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cheese cow- cumin matured', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'organic', availability: true, manufacturer: 'Cheesefarm', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cashew nuts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.4444E2, tax: 6.0, deposit: 0.0, unit_quantity: 22, order_number: ':b936051')
Article.create!(name: 'Hazel white', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':9e3f85b')
Article.create!(name: 'Hazel brown', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':d278041')
Article.create!(name: 'Almond Brown Spanish', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.999E1, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':0b51a8d')
Article.create!(name: 'Brazil nuts (organic)', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 20, order_number: ':01e59e3')
Article.create!(name: 'Organic walnut light halves', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':7ff8587')
Article.create!(name: 'Pinenuts', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'organic',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':aa88d9f')
Article.create!(name: 'Pumpkin', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'organic',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':e63069b')
Article.create!(name: 'Sunflower seeds (organic)', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.999E1, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':0428388')
Article.create!(name: 'Amandel White Spaans', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'organic', availability: true, price: 0.66666E3, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':a8f0734')
Article.create!(name: 'Cashew', supplier_id: 4, article_category_id: 13, unit: 'kg', availability: true,
                price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':1d26958')
Article.create!(name: 'Almonds blanched', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':31439e2')
Article.create!(name: 'Almonds natural', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':9c49374')
Article.create!(name: 'Walnut ELH halves', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.4444E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':92907d1')
Article.create!(name: 'Walnut ELP parts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':395640e')
Article.create!(name: 'Brazil nuts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':710acbb')
Article.create!(name: 'Macadamia type 0', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':bbaf40b')
Article.create!(name: 'Pecan', supplier_id: 4, article_category_id: 13, unit: 'kg', availability: true,
                price: 0.55555E3, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':7958183')
Article.create!(name: 'Hazelnuts natural', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':50392a8')
Article.create!(name: 'Hazelnuts blanched', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':4fe6525')
Article.create!(name: 'Mixed Nuts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c051b22')
Article.create!(name: 'Peanuts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.777E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':f507577')
Article.create!(name: 'Small peanuts', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':ce563bb')
Article.create!(name: 'Medjoul dates', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':8232061')
Article.create!(name: 'Turkish apricots natural', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':185084f')
Article.create!(name: 'Turkish apricots sulfurised', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':2b2fb20')
Article.create!(name: 'Spanish Figs', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.444E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':82590b1')
Article.create!(name: 'Turkish Figs', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.555E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':cabeeb6')
Article.create!(name: 'Sour Apricots South-Africa', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':2ac18b7')
Article.create!(name: 'Blue raisins Flames', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':16bfa75')
Article.create!(name: 'Yellow Raisins', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':1c59324')
Article.create!(name: 'Red Raisins', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c3fcd84')
Article.create!(name: 'Cranberries whole', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.222E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':921c168')
Article.create!(name: 'Dried apples', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.555E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':902c67b')
Article.create!(name: 'Dried plums without core', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.222E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':a847f91')
Article.create!(name: 'Pumpkin seeds', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.111E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':535645f')
Article.create!(name: 'Sunflower seeds', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.666E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':4ab9a83')
Article.create!(name: 'Linseed', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55E0, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':04be223')
Article.create!(name: 'Poppy seeds', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.7777E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':ec5b2b9')
Article.create!(name: 'Pine nuts medium china', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':0e5b0b8')
Article.create!(name: 'Goji berries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':d52ee00')
Article.create!(name: 'Mulberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.5555E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':5f46bd5')
Article.create!(name: 'Peeled Hemp', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.5555E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c39165b')
Article.create!(name: 'Incaberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':8d44fe7')
Article.create!(name: 'Blueberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':9a95422')
Article.create!(name: 'Chia seeds', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55555E3, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':416d57b')
Article.create!(name: 'Coconut grated', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55E0, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':b3f65e4')

## Members & groups

User.create!(id: 1, nick: 'admin', password: 'secret', first_name: 'Anton', last_name: 'Administrator',
             email: 'admin@foo.test', phone: '+4421486548', created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00')
User.create!(id: 2, nick: 'john', password: 'secret', first_name: 'John', last_name: 'Doe',
             email: 'john@doe.test', created_on: 'Sun, 19 Jan 2014 17:38:22 UTC +00:00')
User.create!(id: 3, nick: 'peter', password: 'secret', first_name: 'Peter', last_name: 'Peters',
             email: 'peter@peters.test', phone: '+4711235486811', created_on: 'Sat, 25 Jan 2014 20:20:36 UTC +00:00')
User.create!(id: 4, nick: 'jan', password: 'secret', first_name: 'Jan', last_name: 'Lou',
             email: 'jan@lou.test', created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00')
User.create!(id: 5, nick: 'mary', password: 'secret', first_name: 'Mary', last_name: 'Lou',
             email: 'marie@lou.test', created_on: 'Mon, 03 Feb 2014 11:47:17 UTC +00:00')
User.find_by_nick('mary').update(last_activity: 5.days.ago)

Workgroup.create!(id: 1, name: 'Administrators', description: 'System administrators.',
                  account_balance: 0.0, created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00', role_admin: true, role_suppliers: true, role_article_meta: true, role_finance: true, role_orders: true, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 2, name: 'Finances', account_balance: 0.0,
                  created_on: 'Sun, 19 Jan 2014 17:40:03 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: true, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 3, name: 'Ordering', account_balance: 0.0,
                  created_on: 'Thu, 20 Feb 2014 14:44:47 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: true, role_finance: false, role_orders: true, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 4, name: 'Assortment', account_balance: 0.0,
                  created_on: 'Wed, 09 Apr 2014 12:24:55 UTC +00:00', role_admin: false, role_suppliers: true, role_article_meta: true, role_finance: false, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 5, name: 'Admin Administrator', account_balance: 0.0,
                   created_on: 'Sat, 18 Jan 2014 00:38:48 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, stats: { jobs_size: 0, orders_sum: 1021.74 }, next_weekly_tasks_number: 8, ignore_apple_restriction: true)
Ordergroup.create!(id: 6, name: "Pete's house", account_balance: -0.35E2,
                   created_on: 'Sat, 25 Jan 2014 20:20:37 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'Piet Pieterssen', stats: { jobs_size: 0, orders_sum: 60.96 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 7, name: 'Jan Klaassen', account_balance: -0.35E2,
                   created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'Jan Klaassen', stats: { jobs_size: 0, orders_sum: 0 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 8, name: 'John Doe', account_balance: 0.90E2,
                   created_on: 'Wed, 09 Apr 2014 12:23:29 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, contact_person: 'John Doe', stats: { jobs_size: 0, orders_sum: 0 }, next_weekly_tasks_number: 8, ignore_apple_restriction: false)

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
seed_order(supplier_id: 3, starts: 3.days.ago, ends: 5.days.from_now)
seed_order(supplier_id: 2, starts: 4.days.ago, ends: 4.days.from_now)

## GroupOrders & such

seed_group_orders

## Finances

FinancialTransactionType.create!(id: 1, name: 'Foodcoop', financial_transaction_class_id: 1)

FinancialTransaction.create!(id: 1, ordergroup_id: 5, amount: -0.35E2,
                             note: 'Membership fee for ordergroup', user_id: 1, created_on: 'Sat, 18 Jan 2014 00:38:48 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 3, ordergroup_id: 6, amount: -0.35E2,
                             note: 'Membership fee for ordergroup', user_id: 1, created_on: 'Sat, 25 Jan 2014 20:20:37 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 4, ordergroup_id: 7, amount: -0.35E2,
                             note: 'Membership fee for ordergroup', user_id: 1, created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 5, ordergroup_id: 5, amount: 0.35E2, note: 'payment', user_id: 2,
                             created_on: 'Wed, 05 Feb 2014 16:49:24 UTC +00:00', financial_transaction_type_id: 1)
FinancialTransaction.create!(id: 6, ordergroup_id: 8, amount: 0.90E2, note: 'Bank transfer', user_id: 2,
                             created_on: 'Mon, 17 Feb 2014 16:19:34 UTC +00:00', financial_transaction_type_id: 1)
