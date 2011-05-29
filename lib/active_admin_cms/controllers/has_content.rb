module ActiveAdminCms
  module Controllers
    module HasContent

      module ClassMethods
        def managable_content_for(*args)
          @@contents = args unless args.empty?
          @@contents
        end
      end

      module InstanceMethods
        def managable_content_for(key)
          page_content = Page.content(controller_path, key)
          page_content.nil? ? nil : page_content.content
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.helper_method(:managable_content_for)
      end
    end
  end
end
