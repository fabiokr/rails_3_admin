ActiveAdmin.register Page do
  index do
    column :title do |page|
      #link_to page.title, admin_page_path(page)
    end
    column :description
    column :updated_at
    default_actions
  end
end
