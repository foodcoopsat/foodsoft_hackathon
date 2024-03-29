module FoodsoftDocuments
  class Engine < ::Rails::Engine
    def navigation(primary, context)
      return unless FoodsoftDocuments.enabled?
      return if primary[:foodcoop].nil?

      sub_nav = primary[:foodcoop].sub_navigation
      sub_nav.items <<
        SimpleNavigation::Item.new(primary, :documents, I18n.t('navigation.documents'), context.documents_path)
      # move to right before tasks item
      return unless i = sub_nav.items.index(sub_nav[:tasks])

      sub_nav.items.insert(i, sub_nav.items.delete_at(-1))
    end

    def default_foodsoft_config(cfg)
      cfg[:documents_allowed_extension] = 'gif jpg png txt'
    end
  end
end
