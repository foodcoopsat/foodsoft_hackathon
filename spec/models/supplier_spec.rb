require_relative '../spec_helper'

describe Supplier do
  let(:supplier) { create :supplier }

  it 'has a unique name' do
    supplier2 = build :supplier, name: supplier.name
    expect(supplier2).to be_invalid
  end

  it 'has valid articles' do
    supplier = create :supplier, article_count: true
    supplier.articles.each { |a| expect(a).to be_valid }
  end

  context 'connected to a shared supplier' do
    let(:shared_sync_method) { nil }
    let(:shared_supplier) { create :shared_supplier }
    let(:supplier) { create :supplier, shared_supplier: shared_supplier, shared_sync_method: shared_sync_method }

    let!(:synced_shared_article) { create :shared_article, shared_supplier: shared_supplier }
    let!(:updated_shared_article) { create :shared_article, shared_supplier: shared_supplier }
    let!(:new_shared_article) { create :shared_article, shared_supplier: shared_supplier }

    let!(:removed_article) { create :article, supplier: supplier, order_number: '10001-ABC' }
    let!(:updated_article) do
      updated_shared_article.build_new_article(supplier).tap do |article|
        article_version = article.latest_article_version

        # remove version before save - required to make validation pass (can't validate article_version without existing article_id):
        article.article_versions = []
        article.latest_article_version = nil

        article.shared_updated_on = 1.day.ago
        article.save!

        article_version.article_category = create :article_category
        article_version.unit = '200g'
        article_version.origin = "FubarX1"
        article.article_versions << article_version
        article.reload
      end
    end
    let!(:synced_article) do
      synced_shared_article.build_new_article(supplier).tap do |article|
        article_version = article.latest_article_version

        # remove version before save - required to make validation pass (can't validate article_version without existing article_id):
        article.article_versions = []
        article.latest_article_version = nil

        article.shared_updated_on = 1.day.ago
        article.save!

        article_version.article_category = create :article_category
        article_version.unit = '200g'
        article.article_versions << article_version
        article.reload
      end
    end

    context 'with sync method import' do
      let(:shared_sync_method) { 'import' }

      it 'returns the expected articles' do
        updated_article_pairs, outlisted_articles, new_articles = supplier.sync_all

        expect(updated_article_pairs).to_not be_empty

        index = updated_article_pairs.index { |pair| pair[0].id == updated_article.id }
        expect(index).to_not be_nil
        expect(updated_article_pairs[index][1].keys).to include :origin

        expect(outlisted_articles).to eq [removed_article]

        expect(new_articles).to be_empty
      end
    end

    context 'with sync method all_available' do
      let(:shared_sync_method) { 'all_available' }

      it 'returns the expected articles' do
        updated_article_pairs, outlisted_articles, new_articles = supplier.sync_all

        index = updated_article_pairs.index { |pair| pair[0].id == updated_article.id }
        expect(index).to_not be_nil
        expect(updated_article_pairs[index][1].keys).to include :origin

        expect(outlisted_articles).to eq [removed_article]

        expect(new_articles).to_not be_empty
        expect(new_articles[0].order_number).to eq new_shared_article.number
        expect(new_articles[0].availability).to be true
      end
    end

    context 'with sync method all_unavailable' do
      let(:shared_sync_method) { 'all_unavailable' }

      it 'returns the expected articles' do
        updated_article_pairs, outlisted_articles, new_articles = supplier.sync_all

        index = updated_article_pairs.index { |pair| pair[0].id == updated_article.id }
        expect(index).to_not be_nil
        expect(updated_article_pairs[index][1].keys).to include :origin

        expect(outlisted_articles).to eq [removed_article]

        expect(new_articles).to_not be_empty
        expect(new_articles[0].order_number).to eq new_shared_article.number
        expect(new_articles[0].availability).to be false
      end
    end
  end
end
