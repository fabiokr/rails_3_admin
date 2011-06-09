module AdminHelper
  def icon_link_to(*args)
    image         = args[0]
    options      = args[1] || {}
    html_options = {:title => t("admin.#{image}")}.merge (args[2] || {})

    image = case image
      when :delete
        :trash
      else
        image
    end

    link_to image_tag("/images/admin/icn_#{image}.png"), options, html_options
  end

  def resource_messages
    if resource.respond_to?(:map)
      resource.map{|r| resource_errors(r)}.flatten
    else
      resource_errors(resource)
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "sort_#{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  private

  def resource_errors(resource)
    resource.respond_to?(:errors) ? resource.errors.full_messages : []
  end
end
