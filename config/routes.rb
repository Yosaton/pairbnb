Rails.application.routes.draw do
  # Root redirect
  root "welcome#index"

  # Clearance route overrides
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

	# Resources from rails build
	resources :listing_photos
	resources :avatars
	resources :bookings
	resources :listings
	resources :users
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
