module Admin
  module Models
    module Sortable
      extend ActiveSupport::Concern

      included do
        acts_as_list

        attr_accessor   :sort
        attr_accessible :sort

        after_update  :set_position_on_update

        scope :sorted, (lambda do |*args|
          order('position ASC')
        end)
      end

      module ClassMethods
      end

      module InstanceMethods
        protected

        def set_position_on_update
          new_position, self.sort = sort, nil
          insert_at new_position unless new_position.nil?
        end
      end
    end
  end
end
