module Admin
  module Helpers
    class BreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder

      def render_element(element)
        content = @context.link_to_unless_current(compute_name(element), compute_path(element)) do
          @context.content_tag(:a, compute_name(element), :class => 'current')
        end
        if @options[:tag]
          @context.content_tag(@options[:tag], content)
        else
          content
        end
      end

    end
  end
end
