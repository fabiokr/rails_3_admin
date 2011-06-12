ActiveRecord::ConnectionAdapters::Table.send :include, Admin::Orm::ActiveRecord::SchemaDefinitions
ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Admin::Orm::ActiveRecord::SchemaDefinitions
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Admin::Orm::ActiveRecord::SchemaStatements
