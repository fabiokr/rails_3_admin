# Basic Controller that provides single model default behaviors
# for the index, new, create, edit, update, delete and destroy actions.
class Admin::Controllers::Resource < Admin::Controllers::Base

  before_filter :collection_breadcrumbs, :resource_breadcrumbs
  helper_method :sort_column, :sort_direction

  inherit_resources
  custom_actions :resource => :delete
  respond_to :html

  protected

  # Overrides default to add pagination and sorting
  def end_of_association_chain
    chain = super
    chain = chain.sorted(sort) if chain.respond_to?(:sorted)
    chain = chain.page(params[:page])
    chain
  end

  def collection_breadcrumbs
    if parent?
      # TODO Right now we're extracting the parent_url for the parent collections by hand.
      # Better try to find an automatic way to determine the parent collection url
      add_breadcrumb(Proc.new { |c| parent.class.model_name.human.pluralize }, Proc.new { |c| parent_url.match(/(.*)\/.*/)[1] })
    end

    add_breadcrumb(resource_class.model_name.human.pluralize, Proc.new { |c| collection_url parent? ? parent : nil })
  end

  def resource_breadcrumbs
    i18n_controller_namespace = controller_path.gsub("/", ".")

    i18n_action_name = action_name
    i18n_action_name = 'new' if i18n_action_name == 'create'
    i18n_action_name = 'edit' if i18n_action_name == 'update'
    i18n_action_name = 'delete' if i18n_action_name == 'destroy'

    proc = case action_name
      when 'new' then                        Proc.new { |c| new_resource_path }
      when 'create' then                     Proc.new { |c| collection_path }
      when 'edit' then                       Proc.new { |c| edit_resource_path(resource) }
      when 'delete' then                     Proc.new { |c| delete_resource_path(resource) }
      when 'show', 'update', 'destroy' then  Proc.new { |c| resource_path(resource) }
    end

    add_breadcrumb(I18n.t("admin.#{i18n_action_name}_resource", :resource_name => resource_class.model_name.human), proc) unless proc.nil?
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
