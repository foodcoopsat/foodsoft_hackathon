module SuppliersHelper
  def shared_sync_method_collection
    # TODO: See if we really need the import limit `shared_supplier_article_sync_limit`
    # also see https://github.com/foodcoops/foodsoft/pull/609/files
    Supplier.shared_sync_methods.keys.map do |m|
      [t("suppliers.shared_supplier_methods.#{m}"), m]
    end
  end
end
