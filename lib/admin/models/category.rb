module Admin
  module Models
    module Article
      extend ActiveSupport::Concern

      included do
        include Sortable

        attr_accessible :name

        validates :name, :presence => true, :uniqueness => true

        scope :sorted, order('position ASC')
        scope :for_url_param, lambda { |param| where(:slug => param) }

        before_save    :set_slug
      end

      module ClassMethods
      end

      module InstanceMethods
        private

        def set_slug
          name = self.name
          self.slug = name.parameterize if name
        end
      end
    end
  end
end
