module Admin
  module Models
    module SeoEnable
      extend ActiveSupport::Concern

      included do
        attr_accessible :title, :description, :keywords
      end

      module ClassMethods
      end

      module InstanceMethods
      end
    end
  end
end
