require 'singleton'

module Admin
  class Menu < Array
    include ActionDispatch::Routing::UrlFor

    cattr_accessor :items
    self.items = []

    attr_accessor :title

    def initialize(title, options = {})
      @title = if title.respond_to? :model_name
        proc { options[:plural] ? title.model_name.human.pluralize : title.model_name.human }
      else
        title
      end
    end

    def title
      @title.is_a?(Proc) ? @title.call : @title
    end

    class Item
      attr_accessor :title, :path, :icon

      def initialize(path, options = {})
        @path = path
        @title = options.delete(:title)
        @icon = options.delete(:icon)
      end

      def title
        @title.is_a?(Proc) ? @title.call : @title
      end
    end

    def item(path, options = {})
      push Item.new(path, options)
    end

    def self.configure(&block)
      self.instance_eval &block if block_given?
      self.items
    end

    def self.menu(title, options = {}, &block)
      menu = Menu.new(title, options)
      menu.instance_eval(&block)
      self.items << menu
    end
  end
end
