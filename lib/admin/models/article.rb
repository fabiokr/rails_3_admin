module Admin
  module Models
    module Article
      extend ActiveSupport::Concern

      included do
        include SeoEnable

        attr_accessible :excerpt, :body, :published_at, :publish_now, :highlight

        before_save :set_slug, :set_published

        validates :title, :presence => true, :uniqueness => {:scope => :category_id, :case_sensitive => false, :if => Proc.new { |article| article.respond_to?(:category_id) }}

        scope :unpublished, where(:published_at => nil)
        scope :published, lambda { where(arel_table[:published_at].not_eq(nil)) }
        scope :highlighted, lambda { where(:highlight => true) }
        scope :sorted, (lambda {|*args| order 'highlight DESC, published_at DESC'})
        scope :sorted_admin, (lambda do |*args|
          sort = args.first
          order(sort ? sort : 'created_at DESC')
        end)
        scope :for_url_param, lambda { |param| where(:slug => param) }
      end

      module ClassMethods
      end

      module InstanceMethods

        def to_url_param
          self.slug
        end

        def publish_now=(value)
          @publish_now = (value && !(value === 'false'))
        end

        private

        def set_slug
          self.slug = "#{self.title.parameterize}" if self.title
        end

        def set_published
          self.published_at = DateTime.now if @publish_now
        end
      end
    end
  end
end
