class SuppliersController < ApplicationController
  before_action :authenticate_suppliers, :except => [:index, :list]
  helper :deliveries

  def index
    @suppliers = Supplier.undeleted.order(:name)
    @deliveries = Delivery.recent
  end

  def show
    @supplier = Supplier.find(params[:id])
    @deliveries = @supplier.deliveries.recent
    @orders = @supplier.orders.recent
  end

  # new supplier
  def new
    @supplier = Supplier.new
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def create
    @supplier = Supplier.new(supplier_params)
    @supplier.supplier_category ||= SupplierCategory.first
    if @supplier.save
      flash[:notice] = I18n.t('suppliers.create.notice')
      redirect_to suppliers_path
    else
      render :action => 'new'
    end
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update_attributes(supplier_params)
      flash[:notice] = I18n.t('suppliers.update.notice')
      redirect_to @supplier
    else
      render :action => 'edit'
    end
  end

  def destroy
    @supplier = Supplier.find(params[:id])
    @supplier.mark_as_deleted
    flash[:notice] = I18n.t('suppliers.destroy.notice')
    redirect_to suppliers_path
  rescue => e
    flash[:error] = I18n.t('errors.general_msg', :msg => e.message)
    redirect_to @supplier
  end

  private

  def supplier_params
    params
      .require(:supplier)
      .permit(:name, :address, :phone, :phone2, :fax, :email, :url, :contact_person, :customer_number,
              :iban, :custom_fields, :delivery_days, :order_howto, :note, :supplier_category_id,
              :min_order_quantity, :shared_sync_method, :supplier_remote_source)
  end
end
