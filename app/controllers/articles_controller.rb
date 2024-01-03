class ArticlesController < ApplicationController
  before_action :authenticate_article_meta, :find_supplier

  before_action :load_article, only: [:edit, :update]
  before_action :load_article_units, only: [:edit, :update, :new, :create, :parse_upload, :sync, :update_synchronized]
  before_action :load_article_categories, only: [:edit_all, :migrate_units, :update_all]
  before_action :new_empty_article_ratio, only: [:edit, :edit_all, :migrate_units, :update, :new, :create, :parse_upload, :sync, :update_synchronized]

  def index
    if params['sort']
      sort = case params['sort']
             when "name" then "article_versions.name"
             when "unit" then "article_versions.unit"
             when "article_category" then "article_categories.name"
             when "note" then "article_versions.note"
             when "availability" then "article_versions.availability"
             when "name_reverse" then "article_versions.name DESC"
             when "unit_reverse" then "article_versions.unit DESC"
             when "article_category_reverse" then "article_categories.name DESC"
             when "note_reverse" then "article_versions.note DESC"
             when "availability_reverse" then "article_versions.availability DESC"
             end
    else
      sort = "article_categories.name, article_versions.name"
    end

    @articles = Article.with_latest_versions_and_categories.order(sort).undeleted.where(supplier_id: @supplier, :type => nil)

    if request.format.csv?
      send_data ArticlesCsv.new(@articles, encoding: 'utf-8').to_csv, filename: 'articles.csv', type: 'text/csv'
      return
    end

    @articles = @articles.where('article_versions.name LIKE ?', "%#{params[:query]}%") unless params[:query].nil?

    @articles = @articles.page(params[:page]).per(@per_page)

    respond_to do |format|
      format.html
      format.js { render :layout => false }
    end
  end

  def new
    @article = @supplier.articles.build
    @article.latest_article_version = @article.article_versions.build
    render :layout => false
  end

  def copy
    @article = @supplier.articles.find(params[:article_id]).dup
    render :layout => false
  end

  def edit
    render :action => 'new', layout: false
  end

  def create
    valid = false
    Article.transaction do
      @article = Article.create(supplier_id: @supplier.id)
      @article.attributes = { latest_article_version_attributes: params[:article_version] }
      raise ActiveRecord::Rollback unless @article.valid?

      valid = @article.save
    end

    if valid
      render :layout => false
    else
      render :action => 'new', :layout => false
    end
  end

  # Updates one Article and highlights the line if succeded
  def update
    if @article.update_attributes(latest_article_version_attributes: params[:article_version])
      render :layout => false
    else
      Rails.logger.info @article.errors.to_yaml.to_s
      render :action => 'new', :layout => false
    end
  end

  # Deletes article from database. send error msg, if article is used in a current order
  def destroy
    @article = Article.find(params[:id])
    @article.mark_as_deleted unless @order = @article.in_open_order # If article is in an active Order, the Order will be returned
    render :layout => false
  end

  # Renders a form for editing all articles from a supplier
  def edit_all
    @articles = @supplier.articles.undeleted

    load_article_units
  end

  def migrate_units
    Article.transaction do
      @articles = @supplier.articles.with_latest_versions_and_categories.undeleted.includes(latest_article_version: [:article_unit_ratios])
      @original_units = {}
      @articles.each do |article|
        article_version = article.latest_article_version
        quantity = 1
        ratios = article_version.article_unit_ratios

        @original_units[article.id] = article_version.unit

        next if ratios.length > 1

        if ratios.length == 1 && ratios[0].quantity != 1 && ratios[0].unit == 'XPP'
          quantity = ratios[0].quantity
        end

        conversion_result = ArticleUnitsLib.convert_old_unit(article_version.unit, quantity)

        next if conversion_result.nil?

        article_version.unit = nil
        article_version.supplier_order_unit = conversion_result[:supplier_order_unit]
        article_version.group_order_granularity = conversion_result[:group_order_granularity]
        article_version.group_order_unit = conversion_result[:group_order_unit]

        first_ratio = conversion_result[:first_ratio]
        if first_ratio.nil?
          article_version.article_unit_ratios = []
        else
          article_version.article_unit_ratios = [article_version.article_unit_ratios.build(first_ratio.merge(sort: 1))]
        end
      end

      raise ActiveRecord::Rollback # required as immediate save on article_version.article_unit_ratios cannot be avoided when clearing the array
    end

    load_article_units

    render :edit_all
  end

  # Updates all article of specific supplier
  def update_all
    invalid_articles = false

    begin
      Article.transaction do
        unless params[:articles].blank?
          # Update other article attributes...
          @articles = Article.with_latest_versions_and_categories
                             .includes(latest_article_version: [:article_unit_ratios])
                             .find(params[:articles].keys)
          @articles.each do |article|
            article_version_params = params[:articles][article.id.to_s]
            article_version_params["id"] = article.latest_article_version.id
            unless article.update_attributes(latest_article_version_attributes: article_version_params)
              invalid_articles = true unless invalid_articles # Remember that there are validation errors
            end
          end

          @supplier.update_attribute(:unit_migration_completed, Time.now) if params[:complete_migration]

          raise ActiveRecord::Rollback if invalid_articles # Rollback all changes
        end
      end
    end

    if invalid_articles
      # An error has occurred, transaction has been rolled back.
      flash.now.alert = I18n.t('articles.controller.error_invalid')
      render :edit_all
    else
      # Successfully done.
      redirect_to supplier_articles_path(@supplier), notice: I18n.t('articles.controller.update_all.notice')
    end
  end

  # makes different actions on selected articles
  def update_selected
    raise I18n.t('articles.controller.error_nosel') if params[:selected_articles].nil?

    articles = Article.with_latest_versions_and_categories
                      .includes(latest_article_version: [:article_unit_ratios])
                      .find(params[:selected_articles])
    Article.transaction do
      case params[:selected_action]
      when 'destroy'
        articles.each(&:mark_as_deleted)
        flash[:notice] = I18n.t('articles.controller.update_sel.notice_destroy')
      when 'setNotAvailable'
        articles.each { |a| a.update_attribute(:availability, false) }
        flash[:notice] = I18n.t('articles.controller.update_sel.notice_unavail')
      when 'setAvailable'
        articles.each { |a| a.update_attribute(:availability, true) }
        flash[:notice] = I18n.t('articles.controller.update_sel.notice_avail')
      else
        flash[:alert] = I18n.t('articles.controller.update_sel.notice_noaction')
      end
    end
    # action succeded
    redirect_to supplier_articles_url(@supplier, :per_page => params[:per_page])
  rescue => error
    redirect_to supplier_articles_url(@supplier, :per_page => params[:per_page]),
                :alert => I18n.t('errors.general_msg', :msg => error)
  end

  # lets start with parsing articles from uploaded file, yeah
  # Renders the upload form
  def upload
  end

  # Update articles from a spreadsheet
  def parse_upload
    uploaded_file = params[:articles]['file'] or raise I18n.t('articles.controller.parse_upload.no_file')
    options = { filename: uploaded_file.original_filename }
    options[:outlist_absent] = (params[:articles]['outlist_absent'] == '1')
    options[:convert_units] = (params[:articles]['convert_units'] == '1')
    @updated_article_pairs, @outlisted_articles, @new_articles = @supplier.sync_from_file uploaded_file.tempfile, options
    if @updated_article_pairs.empty? && @outlisted_articles.empty? && @new_articles.empty?
      redirect_to supplier_articles_path(@supplier), :notice => I18n.t('articles.controller.parse_upload.notice')
    end
    @ignored_article_count = 0
  rescue => error
    redirect_to upload_supplier_articles_path(@supplier), :alert => I18n.t('errors.general_msg', :msg => error.message)
  end

  # sync all articles with the external database
  # renders a form with articles, which should be updated
  def sync
    @updated_article_pairs, @outlisted_articles, @new_articles = @supplier.sync_from_remote
    if @updated_article_pairs.empty? && @outlisted_articles.empty? && @new_articles.empty?
      redirect_to supplier_articles_path(@supplier), :notice => I18n.t('articles.controller.parse_upload.notice')
    end
    @ignored_article_count = 0
  rescue => error
    redirect_to upload_supplier_articles_path(@supplier), :alert => I18n.t('errors.general_msg', :msg => error.message)
  end

  # Updates, deletes articles when upload or sync form is submitted
  def update_synchronized
    @outlisted_articles = Article.includes(:latest_article_version).where(article_versions: { id: params[:outlisted_articles]&.values || [] })
    @updated_articles = Article.includes(:latest_article_version).where(article_versions: { id: params[:articles]&.values&.map { |v| v[:id] } || [] })
    @new_articles = (params[:new_articles]&.values || []).map do |a|
      article = @supplier.articles.build
      article_version = article.article_versions.build(a)
      article.article_versions << article_version
      article.latest_article_version = article_version
      article_version.article = article
      article
    end

    has_error = false
    Article.transaction do
      # delete articles
      begin
        @outlisted_articles.each(&:mark_as_deleted)
      rescue
        # raises an exception when used in current order
        has_error = true
      end
      # Update articles
      @updated_articles.each_with_index do |a, index|
        current_params = params[:articles][index.to_s]
        current_params.delete(:id)

        a.latest_article_version.article_unit_ratios.clear
        a.latest_article_version.assign_attributes(current_params)
        a.save
      end or has_error = true
      # Add new articles
      @new_articles.each { |a| a.save or has_error = true }

      raise ActiveRecord::Rollback if has_error
    end

    if !has_error
      redirect_to supplier_articles_path(@supplier), notice: I18n.t('articles.controller.update_sync.notice')
    else
      @updated_article_pairs = @updated_articles.map do |article|
        orig_article = Article.find(article.id)
        [article, orig_article.unequal_attributes(article)]
      end
      flash.now.alert = I18n.t('articles.controller.error_invalid')
      render params[:from_action] == 'sync' ? :sync : :parse_upload
    end
  end

  private

  def load_article
    @article = Article
               .with_latest_versions_and_categories
               .includes(latest_article_version: [:article_unit_ratios])
               .find(params[:id])
  end

  def load_article_units
    additional_units = if !@article.nil?
                         @article.current_article_units
                       elsif !@articles.nil?
                         @articles.map(&:current_article_units)
                                  .flatten
                                  .uniq
                       else
                         []
                       end

    @article_units = ArticleUnit.as_options(additional_units: additional_units)
    @all_units = ArticleUnit.as_hash(additional_units: additional_units)
  end

  def load_article_categories
    @article_categories = ArticleCategory.all
  end

  def new_empty_article_ratio
    @empty_article_unit_ratio = ArticleUnitRatio.new
    @empty_article_unit_ratio.article_version = @article.latest_article_version unless @article.nil?
    @empty_article_unit_ratio.sort = -1
  end

  # @return [Number] Number of articles not taken into account when syncing (having no number)
  def ignored_article_count
    if action_name == 'sync' || params[:from_action] == 'sync'
      @ignored_article_count ||= @supplier.articles.includes(:latest_article_version).undeleted.where(article_versions: { order_number: [nil, ''] }).count
    else
      0
    end
  end
  helper_method :ignored_article_count
end
