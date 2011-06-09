module Admin
  module Helpers
    class BreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::SimpleBuilder

      def render_element(element)
        content = if element == @elements.last
          @context.content_tag(:a, compute_name(element), :class => 'current')
        else
          @context.link_to(compute_name(element), compute_path(element))
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
