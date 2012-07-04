Aggregate::Application.routes.draw do
  get "feed" => "social#index", :as => "feed"

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  root :to => "index#index"

  match '/auth/:provider/callback' => 'authentications#create'
end
