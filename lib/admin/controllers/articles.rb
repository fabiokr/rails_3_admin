module Admin
  module Controllers
    module Articles
      extend ActiveSupport::Concern

      included do
        before_filter :get_categories
        before_filter :get_category
        mattr_accessor :category_model, :article_model, :categories_path, :category_path, :article_path, :categories_title, :paginate
      end

      module ClassMethods
      end

      module InstanceMethods
        def index
          @articles = @category.articles.published.sorted
          @articles = @articles.page(params[:page]).per(paginate) if self.class.paginate
        end

        def show
          unless @article = @category.articles.published.for_url_param(params[:article_id]).first
            raise ActiveRecord::RecordNotFound.new
          end

          add_breadcrumb @article.title, path(self.class.article_path, :category_id => @category.to_url_param, :article_id => @article.to_url_param)
        end

        private

        def get_categories
          @categories = self.class.category_model.sorted
        end

        def get_category
          category_id = params[:category_id]

          if category_id
            unless @category = self.class.category_model.for_url_param(category_id).first
              raise ActiveRecord::RecordNotFound.new
            end

            add_breadcrumb managable_content_for(:title), path(self.class.categories_path)
            add_breadcrumb @category.name, path(self.class.category_path, :category_id => @category.to_url_param)
          else
            redirect_to path(self.class.category_path, :category_id => self.class.category_model.sorted.first.to_url_param)
          end
        end

        def path(path, params = {})
          send "#{path}_path", params
        end
      end

    end
  end
end
