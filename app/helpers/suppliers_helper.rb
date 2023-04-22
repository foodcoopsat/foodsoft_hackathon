module SuppliersHelper
  def shared_sync_method_collection(shared_supplier)
    # TODO
    shared_supplier.shared_sync_methods.map do |m|
      [t("suppliers.shared_supplier_methods.#{m}"), m]
    end
  end
end
