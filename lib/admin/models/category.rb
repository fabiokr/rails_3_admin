module Admin
  module Models
    module Article
      extend ActiveSupport::Concern

      included do
        acts_as_list

        attr_accessor   :sort
        attr_accessible :name, :sort

        validates :name, :presence => true, :uniqueness => true

        scope :sorted, order('position ASC')
        scope :for_url_param, lambda { |param| where(:slug => param) }

        before_save    :set_slug
        after_update  :set_position_on_update
      end

      module ClassMethods
      end

      module InstanceMethods
        def to_url_param
          self.slug
        end

        private

        def set_slug
          name = self.name
          self.slug = name.parameterize if name
        end

        def set_position_on_update
          new_position, self.sort = sort, nil
          insert_at new_position unless new_position.nil?
        end
      end
    end
  end
end
