Aggregate::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  root :to => "index#index"

  match '/auth/:provider/callback' => 'authentications#create'
end
