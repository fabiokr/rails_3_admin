module Admin
  module Models
    module BelongsToCategoryTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
      end

      included do
        should have_db_column(:category_id).of_type(:integer)
        should have_db_index(:category_id)
        should allow_mass_assignment_of(:category_id)
        should validate_presence_of(:category_id)
        should belong_to :category

        test 'should have for_category scope' do
          article = Factory(self.class.article_factory)
          Factory(self.class.article_factory)

          assert_equal article, self.class.article_model.for_category(article.category.id).first
        end
      end
    end
  end
end
