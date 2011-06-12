module Admin
  module Controllers
    class ArticlesCategoriesManagement < Resource

      cattr_accessor :new_articles_path, :articles_path
      helper_method :new_articles_path, :articles_path

      def self.template_lookup_path(param = nil)
        paths = super(param)
        paths << 'admin/articles_categories'
      end

    end
  end
end
