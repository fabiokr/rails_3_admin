module Admin
  module Models
    module ArticleTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
      end

      included do
        include Admin::Models::SortableTest
        include Admin::Models::SeoEnableTest

        mattr_accessor :article_model, :article_factory

        should have_db_column(:title).of_type(:string)
        should have_db_column(:excerpt).of_type(:text)
        should have_db_column(:body).of_type(:text)
        should have_db_column(:published_at).of_type(:datetime)
        should have_db_column(:slug).of_type(:string)

        should have_db_index(:published_at)
        should have_db_index(:slug)

        should allow_mass_assignment_of(:title)
        should allow_mass_assignment_of(:excerpt)
        should allow_mass_assignment_of(:body)
        should allow_mass_assignment_of(:published_at)
        should allow_mass_assignment_of(:published)
        should_not allow_mass_assignment_of(:slug)

        should validate_presence_of(:title)

        test 'should save slug from title and published date' do
          article = Factory(self.class.article_factory, :published_at => DateTime.now)

          assert_equal "#{article.title.parameterize}-#{I18n.l(article.published_at, :format => :url)}", article.slug
        end

        test 'should return the slug on to_url_param' do
          article = Factory(self.class.article_factory, :published_at => DateTime.now)

          assert_equal article.slug, article.to_url_param
        end

        test 'should have unpublished scope' do
          articles = [Factory(self.class.article_factory, :published_at => nil), Factory(self.class.article_factory, :published_at => DateTime.now)]

          assert_equal [articles[0]], self.class.article_model.unpublished.all
        end

        test 'should have published scope' do
          articles = [Factory(self.class.article_factory, :published_at => nil), Factory(self.class.article_factory, :published_at => DateTime.now)]

          assert_equal [articles[1]], self.class.article_model.published.all
        end

        test 'should have sorted scope' do
          assert self.class.article_model.sorted.all
        end

        test 'should have for_url_param scope' do
          article = Factory(self.class.article_factory, :published_at => DateTime.now)

          assert_equal article, self.class.article_model.for_url_param(article.slug).first
        end

        test 'should be able to set published_at thought the published method' do
          article = Factory(self.class.article_factory, :published_at => nil)
          refute article.published

          article.published = true
          assert article.published

          article.published = false
          refute article.published

          article.published = 'true'
          assert article.published

          article.published = 'false'
          refute article.published
        end
      end
    end
  end
end
