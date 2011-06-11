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
      end
    end
  end
end
