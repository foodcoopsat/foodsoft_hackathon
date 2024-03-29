require_relative 'seed_helper'

## Financial transaction classes

FinancialTransactionClass.create!(id: 1, name: 'Standaard')
FinancialTransactionClass.create!(id: 2, name: 'Foodsoft')

## Suppliers & articles

SupplierCategory.create!(id: 1, name: 'Other', financial_transaction_class_id: 1)

Supplier.create!([
                   { id: 1, name: 'Koekenbakker', supplier_category_id: 1,
                     address: 'Dorpsstraat 1, Koekange', phone: '012 3456789', email: 'info@dekoekenbakker.test', min_order_quantity: '100' },
                   { id: 2, name: 'Chocolademakkers', supplier_category_id: 1,
                     address: 'Multatuliweg 1, Amsterdam', phone: '012 3456789', email: 'info@chocolademakkers.test', url: 'http://www.chocolademakkers.test/', contact_person: 'Max Puur', delivery_days: 'di, vr (Amsterdam)' },
                   { id: 3, name: 'Kaasmaker', supplier_category_id: 1, address: 'Waagplein, Alkmaar',
                     phone: '012 3456789', url: 'http://www.kaaskamer.test/' },
                   { id: 4, name: 'Notenhuis', supplier_category_id: 1, address: 'Damrak 1, Amsterdam',
                     phone: '012 3456789', email: 'info@notenhuis.test', url: 'http://www.notenhuis.test/', note: 'leveren in Amsterdam; €9 leverkosten bij bestellingen onder €123' }
                 ])

ArticleCategory.create!(id: 1, name: 'Other', description: 'overig, anders, onbekend')
ArticleCategory.create!(id: 2, name: 'Fruit')
ArticleCategory.create!(id: 3, name: 'Groenten')
ArticleCategory.create!(id: 4, name: 'Aardappels & uien')
ArticleCategory.create!(id: 5, name: 'Brood & Bakkerij')
ArticleCategory.create!(id: 6, name: 'Dranken', description: 'sap, fruitsap, groentesap, frisdrank')
ArticleCategory.create!(id: 7, name: 'Kruiden',
                        description: 'kruiden, specerijen, conserveringsmiddelen, extracten')
ArticleCategory.create!(id: 8, name: 'Zuivel',
                        description: 'melk, boter, room, yoghurt, kaas, eieren, zuivelvervangers')
ArticleCategory.create!(id: 9, name: 'Vis & Zee', description: 'vis, schaaldieren, schelpdieren')
ArticleCategory.create!(id: 10, name: 'Vlees & Gevogelte')
ArticleCategory.create!(id: 11, name: 'Oliën & Vetten')
ArticleCategory.create!(id: 12, name: 'Graan & Peulvruchten')
ArticleCategory.create!(id: 13, name: 'Noten & Zaden')
ArticleCategory.create!(id: 14, name: 'Zoetwaren & Zoetstof')

Article.create!(name: 'Volkoren heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Volkoren half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Volkoren sesam heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Volkoren sesam half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Licht tarwe heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Licht tarwe half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Zonnebloempitbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Zonnebloempitbrood  half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Walnoten vloer heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Walnoten vloer half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kennemerlandbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kennemerlandbrood half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Maisbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Maisbrood  half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 1200 gram heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 1200 gram half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 900 gram heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Oberlander 900 gram half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Speltbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Speltbrood half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Landbrood 900gram heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Landbrood 900gram half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Wit  heel', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Wit  half', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Wit met maanzaad heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Wit met maanzaad half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Vijgenbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Vijgenbrood half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bierborstelbrood heel', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.33E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bierborstelbrood half', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Krentenbol', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.99E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Mueslibol', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Brioche', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.91E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Volkoren croissant', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Croissants', supplier_id: 1, article_category_id: 5, unit: 'stuk', note: 'bio',
                availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kaas croissants', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladecroissants', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Soepstengels wit', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Soepstengels volkoren', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.99E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Pompoenpitten broodjes', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.88E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Witte kadetjes', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.66E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Bruine kadetjes', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.66E0, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Tomaten feta broodje', supplier_id: 1, article_category_id: 5, unit: 'stuk',
                note: 'bio', availability: true, manufacturer: 'De Bakker', origin: 'NL', price: 0.11E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladereep Melk (37%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'bio', availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladereep Puur (68%)', supplier_id: 2, article_category_id: 14, unit: '90gr',
                note: 'bio', availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladereep Drie Mensen Melk (40%)', supplier_id: 2, article_category_id: 14,
                unit: '90gr', note: 'bio', availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladereep Drie Mensen Puur (75%)', supplier_id: 2, article_category_id: 14,
                unit: '90gr', note: 'bio', availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.22E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Chocoladereep Zwaan Puur (75%)', supplier_id: 2, article_category_id: 14,
                unit: '120gr', note: 'bio', availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.66E1, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Cacao nibs', supplier_id: 2, article_category_id: 14, unit: '1 kg', note: 'bio',
                availability: true, manufacturer: 'Chocolademakkers', origin: 'NL', price: 0.10E2, tax: 6.0, deposit: 0.0, unit_quantity: 1)
Article.create!(name: 'Kaas Koe-jong', supplier_id: 3, article_category_id: 8, unit: 'kg', note: 'bio',
                availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.88E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- jong belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 12)
Article.create!(name: 'Kaas koe- extra belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'kaas Koe- oud', supplier_id: 3, article_category_id: 8, unit: 'kg', note: 'bio',
                availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.1375E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'kaas koe -overjarig', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas Koe-brandnetel jong', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- brandnetel jong belegen', supplier_id: 3, article_category_id: 8,
                unit: 'kg', note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- brandnetel belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas Koe-komijn jong', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.99E1, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- komijn jong belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Kaas koe- komijn belegen', supplier_id: 3, article_category_id: 8, unit: 'kg',
                note: 'bio', availability: true, manufacturer: 'Kaasboerderij', origin: 'NL', price: 0.11E2, tax: 6.0, deposit: 0.0, unit_quantity: 8)
Article.create!(name: 'Cashewnoten', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'bio',
                availability: true, price: 0.4444E2, tax: 6.0, deposit: 0.0, unit_quantity: 22, order_number: ':b936051')
Article.create!(name: 'Hazel wit', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'bio',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':9e3f85b')
Article.create!(name: 'Hazel bruin', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'bio',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':d278041')
Article.create!(name: 'Amandel Bruin Spaans', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.999E1, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':0b51a8d')
Article.create!(name: 'Paranoten (bio)', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 20, order_number: ':01e59e3')
Article.create!(name: 'Bio walnoten light halfjes', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':7ff8587')
Article.create!(name: 'Pijnboompitten', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':aa88d9f')
Article.create!(name: 'Pompoen', supplier_id: 4, article_category_id: 13, unit: 'kg', note: 'bio',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':e63069b')
Article.create!(name: 'Zonnepitten (bio)', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.999E1, tax: 6.0, deposit: 0.0, unit_quantity: 25, order_number: ':0428388')
Article.create!(name: 'Amandel Wit Spaans', supplier_id: 4, article_category_id: 13, unit: 'kg',
                note: 'bio', availability: true, price: 0.66666E3, tax: 6.0, deposit: 0.0, unit_quantity: 10, order_number: ':a8f0734')
Article.create!(name: 'Cashew', supplier_id: 4, article_category_id: 13, unit: 'kg', availability: true,
                price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':1d26958')
Article.create!(name: 'Amandelen geblancheerd', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':31439e2')
Article.create!(name: 'Amandelen naturel', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':9c49374')
Article.create!(name: 'Walnoot ELH hafjes', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.4444E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':92907d1')
Article.create!(name: 'Walnoot ELP stukjes', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':395640e')
Article.create!(name: 'Paranoten', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':710acbb')
Article.create!(name: 'Macadamia Stijl 0', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':bbaf40b')
Article.create!(name: 'Pecan', supplier_id: 4, article_category_id: 13, unit: 'kg', availability: true,
                price: 0.55555E3, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':7958183')
Article.create!(name: 'Hazelnoten naturel', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.6666E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':50392a8')
Article.create!(name: 'Hazelnoten geblancheerd', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':4fe6525')
Article.create!(name: 'Gemengde Noten', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.333E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c051b22')
Article.create!(name: "Pinda's", supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.777E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':f507577')
Article.create!(name: "Vliespinda's klein", supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.8888E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':ce563bb')
Article.create!(name: 'Medjoul dadels', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.3333E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':8232061')
Article.create!(name: 'Turkse Abrikozen ongezwaveld', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':185084f')
Article.create!(name: 'Turkse Abrikozen gezwaveld', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':2b2fb20')
Article.create!(name: 'Spaanse Vijgen', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.444E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':82590b1')
Article.create!(name: 'Turkse Vijgen', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.555E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':cabeeb6')
Article.create!(name: 'Zure Abrikozen Zuid Afrika', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':2ac18b7')
Article.create!(name: 'Blauwe rozijnen Flames', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':16bfa75')
Article.create!(name: 'Gele Rozijnen', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':1c59324')
Article.create!(name: 'Rode Rozijnen', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.1111E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c3fcd84')
Article.create!(name: 'Cranberries heel', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.222E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':921c168')
Article.create!(name: 'Gedroogde Appeltjes', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.555E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':902c67b')
Article.create!(name: 'Gedroogde pruimen zonder pit', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.222E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':a847f91')
Article.create!(name: 'Pompoenpitten', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.111E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':535645f')
Article.create!(name: 'Zonnenbloepitten', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.666E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':4ab9a83')
Article.create!(name: 'Lijnzaad', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55E0, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':04be223')
Article.create!(name: 'Maanzaad', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.7777E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':ec5b2b9')
Article.create!(name: 'Pijnboompitten medium china', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':0e5b0b8')
Article.create!(name: 'Goji bessen', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':d52ee00')
Article.create!(name: 'Mulberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.5555E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':5f46bd5')
Article.create!(name: 'Gepelde Hennep', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.5555E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':c39165b')
Article.create!(name: 'Incaberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.888E1, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':8d44fe7')
Article.create!(name: 'Blueberries', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.2222E2, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':9a95422')
Article.create!(name: 'Chia zaad', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55555E3, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':416d57b')
Article.create!(name: 'Cocos Rasp', supplier_id: 4, article_category_id: 13, unit: 'kg',
                availability: true, price: 0.55E0, tax: 6.0, deposit: 0.0, unit_quantity: 1, order_number: ':b3f65e4')

## Members & groups

User.create!(id: 1, nick: 'admin', password: 'secret', first_name: 'Anton', last_name: 'Administrator',
             email: 'admin@foo.test', created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00')
User.create!(id: 2, nick: 'john', password: 'secret', first_name: 'John', last_name: 'Doe',
             email: 'john@doe.test', created_on: 'Sun, 19 Jan 2014 17:38:22 UTC +00:00')
User.create!(id: 3, nick: 'peter', password: 'secret', first_name: 'Peter', last_name: 'Pieterssen',
             email: 'peter@pieterssen.test', created_on: 'Sat, 25 Jan 2014 20:20:36 UTC +00:00')
User.create!(id: 4, nick: 'jan', password: 'secret', first_name: 'Jan', last_name: 'Klaassen',
             email: 'jan@klaassen.test', created_on: 'Mon, 27 Jan 2014 16:22:14 UTC +00:00')
User.create!(id: 5, nick: 'mary', password: 'secret', first_name: 'Marie', last_name: 'Klaassen',
             email: 'mary@klaassen.test', created_on: 'Mon, 03 Feb 2014 11:47:17 UTC +00:00')

Workgroup.create!(id: 1, name: 'Admins', description: 'Beheerders', account_balance: 0.0,
                  created_on: 'Wed, 15 Jan 2014 16:15:33 UTC +00:00', role_admin: true, role_suppliers: true, role_article_meta: true, role_finance: true, role_orders: true, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 2, name: 'Financiën', account_balance: 0.0,
                  created_on: 'Sun, 19 Jan 2014 17:40:03 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: true, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 3, name: 'Bestellen', account_balance: 0.0,
                  created_on: 'Thu, 20 Feb 2014 14:44:47 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: true, role_finance: false, role_orders: true, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Workgroup.create!(id: 4, name: 'Assortiment', account_balance: 0.0,
                  created_on: 'Wed, 09 Apr 2014 12:24:55 UTC +00:00', role_admin: false, role_suppliers: true, role_article_meta: true, role_finance: false, role_orders: false, next_weekly_tasks_number: 8, ignore_apple_restriction: false)
Ordergroup.create!(id: 5, name: 'Admin Administrator', account_balance: 0.0,
                   created_on: 'Sat, 18 Jan 2014 00:38:48 UTC +00:00', role_admin: false, role_suppliers: false, role_article_meta: false, role_finance: false, role_orders: false, stats: { jobs_size: 0, orders_sum: 1021.74 }, next_weekly_tasks_number: 8, ignore_apple_restriction: true)
Ordergroup.create!(id: 6, name: "Peter's huis", account_balance: -0.35E2,
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
seed_order(supplier_id: 3, starts: 2.days.ago, ends: 5.days.from_now)
seed_order(supplier_id: 2, starts: 2.days.ago, ends: 4.days.from_now)

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
