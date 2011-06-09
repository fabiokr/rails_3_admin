require 'singleton'

module Admin
  class Menu < Array
    include ActionDispatch::Routing::UrlFor

    cattr_accessor :items
    self.items = []

    attr_accessor :title

    def initialize(title)
      @title = title
    end

    def title
      @title.is_a?(Proc) ? @title.call : @title
    end

    class Entry
      attr_accessor :title, :path, :icon

      def initialize(title, path, options = {})
        @title = title
        @path = path
        @icon = options.delete(:icon)
      end

      def title
        @title.is_a?(Proc) ? @title.call : @title
      end
    end

    def entry(title, path, options = {})
      push Entry.new(title, path, options)
    end

    def self.configure(&block)
      self.instance_eval &block if block_given?
      self.items
    end

    def self.menu(title, &block)
      menu = Menu.new(title)
      menu.instance_eval(&block)
      self.items << menu
    end
  end
end
