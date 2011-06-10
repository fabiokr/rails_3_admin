module Admin
  module Models
    module SortableTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
      end

      included do
        mattr_accessor :sortable_factory

        should have_db_column(:position).of_type(:integer)

        should have_db_index(:position)

        should allow_mass_assignment_of(:sort)
        should_not allow_mass_assignment_of(:position)

        test 'should be sortable' do
          models = [Factory(self.class.sortable_factory), Factory(self.class.sortable_factory)]
          models[0].sort = 2
          models[0].save!
          assert_equal 2, models[0].position
        end
      end
    end
  end
end
