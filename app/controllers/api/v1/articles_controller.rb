class Api::V1::ArticlesController < Api::V1::BaseController
  skip_before_action :authenticate

  def index
    supplier = Supplier.find_by_external_uuid(params[:shared_supplier_uuid])
    raise ActionController::RoutingError.new('Not Found') if supplier.nil?

    @articles = Article.with_latest_versions_and_categories.undeleted.where(supplier_id: supplier, :type => nil)

    data = @articles.map do |article|
      version_attributes = article.latest_article_version.attributes
      version_attributes.delete_if { |key| key == 'id' || key.end_with?('_id') }

      version_attributes['article_unit_ratios'] = article.latest_article_version.article_unit_ratios.map do |ratio|
        ratio_attributes = ratio.attributes
        ratio_attributes.delete_if { |key| key == 'id' || key.end_with?('_id') }
      end

      version_attributes
    end

    render json: {articles: data}
  end
end
