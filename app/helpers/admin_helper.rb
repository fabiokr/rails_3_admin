module AdminHelper
  def icon_link_to(*args)
    image         = args[0]
    options      = args[1] || {}
    html_options = {:title => t("admin.#{image}")}.merge(args[2] || {})

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
    css_class = column && sort_column && column.to_sym == sort_column.to_sym ? "sort_#{sort_direction}" : nil
    direction = column && sort_column && column.to_sym == sort_column.to_sym && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def form_title(resource)
    resource_name = resource.class.model_name.human
    if action_name == 'new' || action_name == 'create'
      t('admin.new_resource', :resource_name => resource_name)
    elsif action_name == 'edit' || action_name == 'update'
      t('admin.edit_resource', :resource_name => resource_name)
    elsif action_name == 'show'
      t('admin.show_resource', :resource_name => resource_name)
    elsif action_name == 'delete'
      t('admin.delete_resource_confirmation', :resource_name => resource_name)
    end
  end

  def content_form_tag(form, field, editable, options = {})
    label = options.delete(:label) || field

    content_tag :fieldset do
      content = form.label(label)
      content << if editable
        form.text_area(field, :class => 'wysiwyg')
      else
        content_tag(:div, :class => 'clear'){''} + content_tag(:div, :class => 'content') do
          form.object.send(field).html_safe unless form.object.send(field).nil?
        end
      end
    end
  end

  def locale_select
    available_locales = Rails.configuration.available_locales

    html = ''

    if available_locales.size > 1
      html << label_tag(:locale, t('admin.locale_select'))
      html << select_tag(:locale, options_for_select(available_locales.map {|locale| [locale, locale]}, params[:locale]))
    end

    html.html_safe
  end

  def link_to_destroy(resource)
    icon_link_to(:delete, resource_path(resource), :method => :delete, :confirm => t('admin.delete_resource_confirmation', :resource_name => resource.class.model_name.human))
  end

  def highlight_checkbox(form)
    (form.label(:highlight) + form.check_box(:highlight)).html_safe
  end

  def current_path_for_menu?(path)
    @builder ||= Admin::Helpers::BreadcrumbBuilder.new(self, breadcrumbs)
    path = path.is_a?(Symbol) ? send(path) : path

    path == request.path || breadcrumbs.detect do |crumb|
      @builder.send(:compute_path, crumb) == path
    end
  end

  private

  def resource_errors(resource)
    resource.respond_to?(:errors) ? resource.errors.full_messages : []
  end
end
