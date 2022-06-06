class OrderArticlesController < ApplicationController
  before_action :fetch_order, except: :destroy
  before_action :authenticate_finance_or_invoices, except: [:new, :create]
  before_action :authenticate_finance_orders_or_pickup, except: [:edit, :update, :destroy]
  before_action :load_order_article, only: [:edit, :update]
  before_action :load_article_units, only: [:edit, :update]
  before_action :new_empty_article_ratio, only: [:edit, :update]

  layout false  # We only use this controller to serve js snippets, no need for layout rendering

  def new
    @order_article = @order.order_articles.build(params[:order_article])
  end

  def create
    # The article may be ordered with zero units - in that case do not complain.
    #   If order_article is ordered and a new order_article is created, an error message will be
    #   given mentioning that the article already exists, which is desired.
    @order_article = @order.order_articles.where(:article_id => params[:order_article][:article_id]).first
    unless @order_article && @order_article.units_to_order == 0
      @order_article = @order.order_articles.build(params[:order_article])
    end
    @order_article.save!
  rescue
    render action: :new
  end

  def edit; end

  def update
    # begin
    price_params = params.require(:article_price).permit(:id, :unit, :supplier_order_unit, :minimum_order_quantity, :billing_unit, :group_order_granularity, :group_order_unit, :price, :price_unit, :tax, :deposit, article_unit_ratios_attributes: [:sort, :quantity, :unit])
    @order_article.update_article_and_price!(params[:order_article], params[:article], price_params)
    # rescue
    #   render action: :edit
    # end
  end

  def destroy
    @order_article = OrderArticle.find(params[:id])
    # only destroy if there are no associated GroupOrders; if we would, the requested
    # quantity and tolerance would be gone. Instead of destroying, we set all result
    # quantities to zero.
    if @order_article.group_order_articles.count == 0
      @order_article.destroy
    else
      @order_article.group_order_articles.each { |goa| goa.update_attribute(:result, 0) }
      @order_article.update_results!
    end
  end

  private

  def fetch_order
    @order = Order.find(params[:order_id])
  end

  def authenticate_finance_orders_or_pickup
    return if current_user.role_finance? || current_user.role_orders?

    return if current_user.role_pickups? && !@order.nil? && @order.state == 'finished'

    deny_access
  end

  def load_order_article
    @order_article = OrderArticle.includes(article: [:article_unit_ratios]).find(params[:id])
  end

  def load_article_units
    @article_units = ArticleUnits.as_options
  end

  def new_empty_article_ratio
    @empty_article_unit_ratio = ArticleUnitRatio.new
    @empty_article_unit_ratio.article_price = @order_article.price
    @empty_article_unit_ratio.sort = -1
  end
end
