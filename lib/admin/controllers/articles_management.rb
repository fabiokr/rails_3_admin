module Admin
  module Controllers
    class ArticlesManagement < Resource

      cattr_accessor :category_path, :categories_path
      helper_method :category_path, :categories_path

      has_scope :for_category

      def self.configure_articles_and_category(article_class)
        defaults :resource_class => article_class, :collection_name => 'articles', :instance_name => 'article'
      end

      def self.template_lookup_path(param = nil)
        paths = super(param)
        paths << 'admin/articles'
      end

      protected

      def build_resource
        resource = super
        resource.category_id = params[:category_id] if params[:category_id]
        resource
      end

    end
  end
end
