module ActiveAdminCms
  module Controllers
    module HasContent
      extend ActiveSupport::Concern

      included do
        class_attribute :_contents
        self._contents = []

        helper_method :managable_content_for
      end

      module ClassMethods
        def managable_content_for(*args)
          self._contents = args unless args.empty?
          self._contents
        end
      end

      module InstanceMethods
        def managable_content_for(key)
          page_content = Page.content(controller_path, key)
          page_content.nil? ? nil : page_content.content
        end
      end
    end
  end
end
