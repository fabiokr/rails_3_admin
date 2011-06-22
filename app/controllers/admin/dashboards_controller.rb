class Admin::DashboardsController < Admin::Controllers::Base

  def show
    @panels = [:pages_dashboard_panel]
  end

end
