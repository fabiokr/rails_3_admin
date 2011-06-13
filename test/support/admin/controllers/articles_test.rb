module Admin
  module Controllers
    module ArticlesTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
        def setup
          @categories = [Factory(self.class.category_factory), Factory(self.class.category_factory)]
          @categories.each do |c|
            (1..3).each {|i| Factory(self.class.article_factory, :category => c, :published_at => DateTime.now) }
          end
          @category = @categories.first
        end

        private

        def path(path, params = {})
          send("#{path}_path", params)
        end
      end

      included do
        mattr_accessor :category_factory, :article_factory

        test 'on index should redirect if category_id is empty' do
          get :index

          assert redirect_to(path(@controller.category_path, :category_id => @controller.category_model.sorted.first.slug))
        end

        test 'on index should list the category published articles' do
          get :index, :category_id => @category.slug

          assert_equal @category, assigns[:category]
          assert_equal @controller.category_model.sorted, assigns[:categories]

          if @controller.class.paginate
            assert_equal @category.articles.published.sorted.page(nil).per(@controller.class.paginate), assigns[:articles]
          else
            assert_equal @category.articles.published.sorted, assigns[:articles]
          end
        end

        test 'on index should set breadcrumb' do
          get :index, :category_id => @category.slug

          assert @controller.send(:breadcrumbs).detect{|crumb| crumb.path == path(@controller.categories_path)}
          assert @controller.send(:breadcrumbs).detect{|crumb| crumb.path == path(@controller.category_path, :category_id => @category.slug)}
        end

        test 'on index should raise in case of invalid article_category' do
          assert_raises ActiveRecord::RecordNotFound do
            get :index, :category_id => 'invalid'
          end
        end

        test 'on show should list published article' do
          article = @category.articles.published.first

          get :show, :category_id => @category.slug, :article_id => article.slug

          assert_equal article, assigns[:article]
          assert_equal @category, assigns[:category]
          assert_equal @controller.category_model.sorted, assigns[:categories]
        end

        test 'on show should set breadcrumb' do
          article = @category.articles.published.first

          get :show, :category_id => @category.slug, :article_id => article.slug

          assert @controller.send(:breadcrumbs).detect{|crumb| crumb.path == path(@controller.categories_path)}
          assert @controller.send(:breadcrumbs).detect{|crumb| crumb.path == path(@controller.category_path, :category_id => @category.slug)}
          assert @controller.send(:breadcrumbs).detect{|crumb| crumb.path == path(@controller.article_path, :category_id => article.category.slug, :article_id => article.slug)}
        end

        test 'on show should raise if article is invalid' do
          assert_raise ActiveRecord::RecordNotFound do
            get :show, :category_id => @category.slug, :article_id => 'invalid'
          end
        end
      end

    end
  end
end
