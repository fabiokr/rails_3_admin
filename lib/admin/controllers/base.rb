module Admin
  module Controllers
    class Base < ActionController::Base
      self.responder = Responder
      respond_to :html

      protect_from_forgery
      before_filter :authenticate_admin_user!
      layout proc{ |c| c.request.xhr? ? false : 'admin' }
      attr_reader :resource
      helper_method :resource
      render_inheritable

      add_breadcrumb I18n.t('app'), :admin_dashboard_path

      def self.template_lookup_path(param = nil)
        ['admin/base']
      end

      protected

      # TODO Remove this maybe?
      def respond_with(*args)
        @resource = [:admin] + args
        super(*(@resource))
      end

    end
  end
end
