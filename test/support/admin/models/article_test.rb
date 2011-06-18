module Admin
  module Models
    module ArticleTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
      end

      included do
        include Admin::Models::SeoEnableTest

        mattr_accessor :article_model, :article_factory

        should have_db_column(:title).of_type(:string)
        should have_db_column(:slug).of_type(:string)
        should have_db_column(:excerpt).of_type(:text)
        should have_db_column(:body).of_type(:text)
        should have_db_column(:published_at).of_type(:datetime)
        should have_db_column(:highlight).of_type(:boolean)

        should have_db_index(:published_at)
        should have_db_index(:slug)
        should have_db_index(:highlight)

        should allow_mass_assignment_of(:title)
        should allow_mass_assignment_of(:excerpt)
        should allow_mass_assignment_of(:body)
        should allow_mass_assignment_of(:published_at)
        should allow_mass_assignment_of(:publish_now)
        should allow_mass_assignment_of(:highlight)

        should_not allow_mass_assignment_of(:slug)

        should validate_presence_of(:title)

        test 'should validate uniqueness of title within a category' do
          article = Factory(self.class.article_factory)

          if article.respond_to? :category_id
            assert_raise ActiveRecord::RecordInvalid do
              Factory(self.class.article_factory, :title => article.title, :category_id => article.category_id)
            end

            Factory(self.class.article_factory, :title => article.title, :category_id => 9999)
          end
        end

        test 'should save slug from title' do
          article = Factory(self.class.article_factory)

          assert_equal "#{article.title.parameterize}", article.slug
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

        test 'should be able to set published_at trought the publish_now method' do
          article = Factory(self.class.article_factory, :published_at => nil)
          assert !article.published_at

          article.publish_now = true
          article.save!
          assert article.published_at
        end
      end
    end
  end
end
