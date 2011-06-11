module Admin
  module Models
    module BelongsToCategory
      extend ActiveSupport::Concern

      included do
        attr_accessible :category_id
        validates :category_id, :presence => true
      end

      module ClassMethods
        def belongs_to_category(klass)
          belongs_to :category, :class_name => klass.to_s, :foreign_key => 'category_id'
        end
      end

      module InstanceMethods
      end
    end
  end
end
