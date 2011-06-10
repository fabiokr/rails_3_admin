module Admin
  module Models
    module CategoryTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
        def setup
          @category = Factory(self.class.category_factory)
        end
      end

      included do
        include Admin::Models::SortableTest

        mattr_accessor :category_model, :category_factory

        should have_db_column(:name).of_type(:string)
        should have_db_column(:slug).of_type(:string)
        should have_db_column(:position).of_type(:integer)

        should have_db_index(:slug)
        should have_db_index(:position)

        should allow_mass_assignment_of(:name)
        should allow_mass_assignment_of(:sort)
        should_not allow_mass_assignment_of(:slug)

        should validate_presence_of(:name)

        should have_many(:articles)

        test 'should validate uniqueness of name' do
          category = Factory(self.class.category_factory)

          assert_raise ActiveRecord::RecordInvalid do
            Factory(self.class.category_factory, :name => category.name)
          end
        end

        test 'should save slug from name' do
          assert_equal @category.name.parameterize, @category.slug
        end

        test 'should return the slug on to_url_param' do
          assert_equal @category.slug, @category.to_url_param
        end

        test 'should have sorted scope' do
          Factory(self.class.category_factory)

          assert_equal self.class.category_model.order('position ASC').all, self.class.category_model.sorted.all
        end

        test 'should have for_url_param scope' do
          assert_equal @category, self.class.category_model.for_url_param(@category.slug).first
        end
      end
    end
  end
end
