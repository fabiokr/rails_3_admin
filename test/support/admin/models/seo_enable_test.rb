module Admin
  module Models
    module SeoEnableTest
      extend ActiveSupport::Concern

      module ClassMethods
      end

      module InstanceMethods
      end

      included do
        mattr_accessor :sortable_factory

        should have_db_column(:title).of_type(:string)
        should have_db_column(:description).of_type(:string)
        should have_db_column(:keywords).of_type(:string)

        should allow_mass_assignment_of(:title)
        should allow_mass_assignment_of(:description)
        should allow_mass_assignment_of(:keywords)
      end
    end
  end
end
