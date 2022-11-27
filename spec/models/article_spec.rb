require_relative '../spec_helper'

describe Article do
  let(:supplier) { create :supplier }
  let(:article) { create :article, supplier: supplier }
  let(:user) { create :user, groups: [create(:ordergroup)] }

  it 'has a unique name' do
    article_version_copy = article.latest_article_version.dup
    article2 = FactoryBot.build :article, name: article.name, supplier_id: article.supplier_id, latest_article_version: article_version_copy
    article2.latest_article_version.article = article2
    expect(article2.latest_article_version).to be_invalid
  end

  it 'computes the gross price correctly' do
    article.deposit = 0
    article.tax = 12
    expect(article.gross_price).to eq((article.price * 1.12).round(2))
    article.deposit = 1.20
    expect(article.gross_price).to eq(((article.price + 1.20) * 1.12).round(2))
  end

  it 'gross price >= net price' do
    expect(article.gross_price).to be >= article.price
  end

  it 'computes the fc price correctly' do
    expect(article.fc_price).to eq((article.gross_price * 1.05).round(2))
  end

  it 'knows when it is deleted' do
    expect(supplier.deleted?).to be false
    supplier.mark_as_deleted
    expect(supplier.deleted?).to be true
  end

  it "doesn't keep an article history for articles not referenced by closed orders" do
    expect(article.article_versions.map(&:price)).to eq([article.price])
    oldprice = article.price
    sleep 1 # so that the new price really has a later creation time
    article.price += 1
    article.save!
    expect(article.article_versions.reload.map(&:price)).to eq([article.price])
  end

  it 'keeps an article history for articles referenced by closed orders' do
    order = create :order, created_by: user, starts: Date.yesterday, ends: 1.hour.ago, end_action: :auto_close
    order.close!(user)
    article = order.order_articles.first.article_version.article

    expect(article.article_versions.map(&:price)).to eq([article.price])
    oldprice = article.price

    sleep 1 # so that the new price really has a later creation time
    article.price += 1
    article.save!
    expect(article.article_versions.reload.map(&:price)).to eq([article.price, oldprice])
  end

  it 'is not in an open order by default' do
    expect(article.in_open_order).to be_nil
  end

  it 'is knows its open order' do
    order = create :order, supplier: supplier, article_ids: [article.id]
    expect(article.in_open_order).to eq(order)
  end

  it 'has no shared article by default' do
    expect(article.shared_article).to be_nil
  end

  describe 'connected to a shared database', :type => :feature do
    let(:shared_article) { create :shared_article }
    let(:supplier) { create :supplier, shared_supplier_id: shared_article.supplier_id }
    let(:article) do
      article = create(:article, supplier: supplier)
      article_version = article.latest_article_version
      article_version.order_number = shared_article.number
      article_version.save
      article
    end

    it 'can be found in the shared database' do
      expect(article.shared_article).to_not be_nil
    end

    it 'can find updates' do
      changed = article.shared_article_changed?
      expect(changed).to_not be_falsey
      expect(changed.length).to be > 1
    end

    it 'can be synchronised' do
      # TODO move article sync from supplier to article
      article # need to reference for it to exist when syncing
      sync_data = supplier.sync_all
      updated_article = sync_data[0].select { |s| s[0].id == article.id }.first[0]
      version_attributes = updated_article.latest_article_version.attributes.reject { |k, v| k == 'id' }
      version_attributes[:id] = article.latest_article_version.id
      article.update_attributes(latest_article_version_attributes: version_attributes)
      expect(article.name).to eq(shared_article.name)
      # now synchronising shouldn't change anything anymore
      expect(article.shared_article_changed?).to be_falsey
    end

    it 'does not need to synchronise an imported article' do
      article = shared_article.build_new_article(supplier)
      article.latest_article_version.article_category = create :article_category
      expect(article.shared_article_changed?).to be_falsey
    end

    it 'adapts to foodcoop units when synchronising' do
      shared_article.unit = '1kg'
      shared_article.unit_quantity = 1
      shared_article.save!
      article = shared_article.build_new_article(supplier)
      article_version = article.latest_article_version

      # remove version before save - required to make validation pass (can't validate article_version without existing article_id):
      article.article_versions = []
      article.latest_article_version = nil

      article.shared_updated_on -= 1 # to make update do something
      article.save!

      article_version.article_category = create :article_category
      article_version.unit = '200g'
      article.article_versions << article_version
      article.reload
      # TODO get sync functionality in article
      sync_data = supplier.sync_all
      updated_article = sync_data[0].select { |s| s[0].id == article.id }.first[0]
      version_attributes = updated_article.latest_article_version.attributes.reject { |k, v| k == 'id' }
      version_attributes[:article_unit_ratios_attributes] = updated_article.latest_article_version.article_unit_ratios.map(&:attributes)
      version_attributes[:id] = article.latest_article_version.id
      article.update_attributes(latest_article_version_attributes: version_attributes)

      expect(article.unit).to eq '200g'
      expect(article.unit_quantity).to eq 5
      expect(article.price).to be_within(0.005).of(shared_article.price / 5)
    end

    it 'does not synchronise when it has no order number' do
      article.update_attributes :order_number => nil
      expect(supplier.sync_all).to eq [[], [], []]
    end
  end
end
