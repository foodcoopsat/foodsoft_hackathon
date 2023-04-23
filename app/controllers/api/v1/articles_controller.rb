class Api::V1::ArticlesController < Api::V1::BaseController
  skip_before_action :authenticate

  def index
    supplier = Supplier.find_by_external_uuid(index_params.fetch(:shared_supplier_uuid))
    raise ActionController::RoutingError, 'Not Found' if supplier.nil?

    @articles = Article.with_latest_versions_and_categories.undeleted.where(supplier_id: supplier, :type => nil)
    @articles = @articles.where('article_versions.updated_at > ?', index_params[:updated_after].to_datetime) unless index_params[:updated_after].nil?

    data = @articles.map do |article|
      version_attributes = article.latest_article_version.attributes
      version_attributes.delete_if { |key| key == 'id' || key.end_with?('_id') }

      version_attributes['article_unit_ratios'] = article.latest_article_version.article_unit_ratios.map do |ratio|
        ratio_attributes = ratio.attributes
        ratio_attributes.delete_if { |key| key == 'id' || key.end_with?('_id') }
      end

      version_attributes
    end

    latest_update = data.pluck('updated_at').map(&:utc).max

    render json: { articles: data, latest_update: latest_update }
  end

  protected

  def index_params
    params.permit(:shared_supplier_uuid, :updated_after)
  end
end
