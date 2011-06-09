class Admin::DemosController < Admin::Controllers::Base

  def show
    flash[:notice]  = "Notice message"
    flash[:alert]   = "Alert message"
    flash[:success] = "Success message"
    flash[:error]   = "Error message"
  end

end
