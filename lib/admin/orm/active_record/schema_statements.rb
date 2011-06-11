module Admin
  module Orm
    module ActiveRecord
      module SchemaStatements

        def article_indexes(table)
          add_index table, :published_at
          add_index table, :slug
          sortable_indexes table
        end

        def category_indexes(table)
          add_index table, :slug
          sortable_indexes table
        end

        def belongs_to_category_indexes(table)
          add_index table, :category_id
        end

        def sortable_indexes(table)
          add_index table, :position
        end

      end
    end
  end
end
