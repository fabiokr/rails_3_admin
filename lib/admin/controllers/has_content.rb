module Admin
  module Controllers
    module HasContent
      extend ActiveSupport::Concern

      included do
        class_attribute :_contents
        self._contents = []

        mattr_accessor :contents_ignore_namespace

        helper_method :managable_content_for
      end

      module ClassMethods
        def managable_content_for(*args)
          self._contents = args unless args.empty?
          self._contents
        end

        def managable_content_ignore_namespace(*args)
          @@contents_ignore_namespace ||= []
          @@contents_ignore_namespace += args unless args.empty?
          @@contents_ignore_namespace
        end
      end

      module InstanceMethods
        def managable_content_for(key)
          content, page = nil, Page.for_controller(controller_path)

          if page && Page.accessible_attributes.deny?(key) && key != :updated_at
            content = page.page_contents.for_key(key).first
            content = (content.nil? || content.content.nil?) ? nil : content.content.html_safe
          elsif page
            content = page.send(key)
          end

          content
        end
      end
    end
  end
end
