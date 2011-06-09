ActiveAdminBase::Application.routes.draw do

  devise_for :admin_users, :path => 'admin'

  match 'admin' => 'admin/dashboards#show'
  namespace 'admin' do
    resource :dashboard, :only => [:show]
    resource :demo, :only => [:show]
  end

  resources :homes, :only => [:index]
  root :to => "homes#index"
end
