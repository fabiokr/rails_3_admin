# Basic Controller that provides single model default behaviors
# for the index, new, create, edit, update, delete and destroy actions.
#
# You can change default logic to retrieve resources by reimplementing
# the resource_index, resource_new, resource_create, resource_edit,
# resource_update, resource_delete and resource_destroy methods
class Admin::Controllers::Resource < Admin::Controllers::Base

  INDEX_BREADCRUMB_ACTIONS = ['index', 'edit', 'update', 'delete', 'destroy']
  before_filter :resource_breadcrumbs
  helper_method :sort_column, :sort_direction
  mattr_writer :resource_class

  def self.resource_class
    @@resource_class ||= controller_name.singularize.camelize.constantize
  end

  def self.resource_class_singular
    resource_class.name.singularize.underscore
  end

  def self.resource_class_plural
    resource_class.name.pluralize.underscore
  end

  def index
    respond_with(resource_index)
  end

  def new
    respond_with(resource_new)
  end

  def create
    resource = resource_create
    resource.save
    respond_with(resource)
  end

  def edit
    respond_with(resource_edit)
  end

  def update
    resource = resource_update
    resource.update_attributes params[self.class.resource_class_singular]
    respond_with(resource)
  end

  def delete
    respond_with(resource_delete)
  end

  def destroy
    resource = resource_destroy
    resource.destroy
    respond_with(resource)
  end

  protected

  def set_resource(name, value)
    instance_variable_set "@#{name}".to_sym, value
  end

  def resource_index
    resource = self.class.resource_class
    resource = resource.sorted(sort) if resource.respond_to?(:sorted)
    resource = resource.page(params[:page])
    set_resource self.class.resource_class_plural, resource
  end

  def resource_new
    set_resource self.class.resource_class_singular, self.class.resource_class.new
  end

  def resource_create
    attributes = params[self.class.resource_class_singular]
    set_resource self.class.resource_class_singular, self.class.resource_class.new(attributes)
  end

  def resource_edit
    set_resource self.class.resource_class_singular, self.class.resource_class.find(params[:id])
  end

  def resource_update
    resource_edit
  end

  def resource_delete
    resource_edit
  end

  def resource_destroy
    resource_edit
  end

  def resource_breadcrumbs
    i18n_controller_namespace = controller_path.gsub("/", ".")

    i18n_action_name = action_name
    i18n_action_name = 'new' if i18n_action_name == 'create'
    i18n_action_name = 'edit' if i18n_action_name == 'update'
    i18n_action_name = 'delete' if i18n_action_name == 'destroy'

    url_action = action_name
    url_action = nil if url_action == 'create' || url_action == 'update' || url_action == 'destroy'

    if INDEX_BREADCRUMB_ACTIONS.include?(action_name)
      add_breadcrumb I18n.t("#{i18n_controller_namespace}.index"), {:controller => controller_path, :action => :index}
    end

    if action_name != 'index'
      add_breadcrumb I18n.t("#{i18n_controller_namespace}.#{i18n_action_name}"), Proc.new { |c| polymorphic_url(@resource, :action => url_action) }
    end
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
    self.class.resource_class.column_names.include?(params[:sort]) ? params[:sort] : nil
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : nil
  end
end
