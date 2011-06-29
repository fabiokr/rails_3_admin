module Admin
  module Orm
    module ActiveRecord
      module SchemaDefinitions

        def article_fields
          column :title, :string
          column :slug, :string
          column :description, :string
          column :keywords, :string
          column :excerpt, :text
          column :body, :text
          column :published_at, :datetime
          column :highlight, :boolean
          timestamps
        end

        def category_fields
          column :name, :string
          column :slug, :string
          column :position, :integer
          sortable_fields
          timestamps
        end

        def belongs_to_category_fields
          column :category_id, :integer
        end

        def sortable_fields
          column :position, :integer
        end

        def locale_fields
          column :locale, :string
        end

      end
    end
  end
end
