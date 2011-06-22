class PagesDashboardPanelCell < Cell::Rails
  helper AdminHelper

  def display
    @pages = Admin::Page.available.sorted('updated_at DESC').limit(5)
    render
  end

end
