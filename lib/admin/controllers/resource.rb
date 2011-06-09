# Basic Controller that provides single model default behaviors
# for the index, new, create, edit, update, delete and destroy actions.
class Admin::Controllers::Resource < Admin::Controllers::Base

  before_filter :resource_breadcrumbs
  helper_method :sort_column, :sort_direction

  inherit_resources
  custom_actions :resource => :delete
  respond_to :html

  protected

  # Overrides default to add pagination and sorting
  def collection
    get_collection_ivar || begin
      c = end_of_association_chain
      c = c.sorted(sort) if c.respond_to?(:sorted)
      c = c.page(params[:page])
      set_collection_ivar(c.respond_to?(:scoped) ? c.scoped : c.all)
    end
  end

  def resource_breadcrumbs
    i18n_controller_namespace = controller_path.gsub("/", ".")

    i18n_action_name = action_name
    i18n_action_name = 'new' if i18n_action_name == 'create'
    i18n_action_name = 'edit' if i18n_action_name == 'update'
    i18n_action_name = 'delete' if i18n_action_name == 'destroy'

    url_action = action_name
    url_action = nil if url_action == 'create' || url_action == 'update' || url_action == 'destroy'

    if i18n_action_name != 'new'
      add_breadcrumb resource_class.model_name.human.pluralize, collection_path
    end

    if i18n_action_name == 'show'
      proc = Proc.new { |c| resource_path(resource) }
    elsif i18n_action_name == 'edit'
      proc = Proc.new { |c| edit_resource_path(resource) }
    elsif i18n_action_name == 'delete'
      proc = Proc.new { |c| delete_resource_path(resource) }
    end

    add_breadcrumb(I18n.t("admin.#{i18n_action_name}_resource", :resource_name => resource.class.model_name.human), proc) unless proc.nil?
  end

  def sort
    if sort_column && sort_direction
      "#{sort_column} #{sort_direction}"
    elsif sort_column
      sort_column
    else
      nil
    end
  end

  def sort_column
    resource_class.column_names.include?(params[:sort]) ? params[:sort] : nil
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
  end
end
