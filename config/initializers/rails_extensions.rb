# adds GET /resource/:id/delete to all singular and plural routes
# works with the :only and :except options for resources() and resource()
module ActionDispatch::Routing::Mapper::Resources

  class Resource
    # nodoc
    def default_actions_with_delete_action(*args)
      actions = default_actions_without_delete_action(*args)
      [actions, :delete].flatten
    end
    alias_method_chain :default_actions, :delete_action
  end


  # nodoc
  def resource_with_delete_action(*resources, &block)
    resource_without_delete_action(*resources) do
      block.call if block
      get(:delete, :on => :member) if parent_resource.actions.include?(:delete)
    end
    self
  end
  alias_method_chain :resource, :delete_action


  # nodoc
  def resources_with_delete_action(*resources, &block)
    resources_without_delete_action(*resources) do
      block.call if block
      get(:delete, :on => :member) if parent_resource.actions.include?(:delete)
    end
    self
  end
  alias_method_chain :resources, :delete_action

end

ActiveRecord::ConnectionAdapters::Table.send :include, Admin::Orm::ActiveRecord::SchemaDefinitions
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Admin::Orm::ActiveRecord::SchemaDefinitions
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Admin::Orm::ActiveRecord::SchemaStatements
