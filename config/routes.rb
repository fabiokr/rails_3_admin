ActiveAdminBase::Application.routes.draw do
  resources :homes, :only => [:index]
  root :to => "homes#index"
end
