module FoodsoftWiki
  class Engine < ::Rails::Engine
    def navigation(primary, ctx)
      return unless FoodsoftWiki.enabled?

      primary.item :wiki, I18n.t('navigation.wiki.title'), '#', id: nil do |subnav|
        subnav.item :wiki_home, I18n.t('navigation.wiki.home'), ctx.wiki_path, id: nil
        subnav.item :all_pages, I18n.t('navigation.wiki.all_pages'), ctx.all_pages_path, id: nil
      end
      # move this last added item to just after the foodcoop menu
      return unless i = primary.items.index(primary[:foodcoop])

      primary.items.insert(i + 1, primary.items.delete_at(-1))
    end

    def default_foodsoft_config(cfg)
      cfg[:use_wiki] = true
    end

    initializer 'foodsoft_wiki.assets.precompile' do |app|
      app.config.assets.precompile += %w[icons/feed-icon-14x14.png]
    end
  end
end
