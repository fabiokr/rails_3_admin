module Admin
  module Models
    module Article
      extend ActiveSupport::Concern

      included do
        include Sortable
        include SeoEnable

        attr_accessible :title, :excerpt, :body, :published_at, :published, :category_id

        before_save :set_slug

        validates :title, :presence => true
        validates :category_id, :presence => true

        scope :unpublished, where(:published_at => nil)
        scope :published, lambda { where(arel_table[:published_at].not_eq(nil)) }
        scope :sorted, order('position ASC')
        scope :for_url_param, lambda { |param| where(:slug => param) }
      end

      module ClassMethods
      end

      module InstanceMethods

        def to_url_param
          self.slug
        end

        def published
          published_at.nil? ? false : true
        end

        def published=(value)
          if (!value || value === 'false') && published_at
            self.published_at = nil
          elsif value && published_at.nil?
            self.published_at = DateTime.now
          end
        end

        private

        def set_slug
          published_at, title = self.published_at, self.title
          self.slug = "#{title.parameterize}-#{I18n.l(published_at, :format => :url)}" if title && published_at
        end
      end
    end
  end
end
