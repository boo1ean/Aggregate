Aggregate::Application.routes.draw do
  get    "feed"     => "social#index", :as => "feed"
  delete "auth/:id" => "authentications#destroy", :as => "destroy_auth"

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  root :to => "index#index"

  match '/auth/:provider/callback' => 'authentications#create'
end
