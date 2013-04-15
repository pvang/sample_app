SampleApp::Application.routes.draw do

  get "users/new" # auto created by controller (we keep this to work for now)

# un-named routes
  # get "static_pages/home" 

  # get "users/new"

  # get "static_pages/help"
  # get "static_pages/about"
  # get "static_pages/contact"

# named routes
  # match '/', to: 'static_pages#home' # we could use this to establish route mapping for the home page, but we'll do something else--scroll down on this page and look for the many stars
  # root :to => 'welcome#index' # we won't do this because we're deleting our public/index.html file
  root :to => 'static_pages#home' # call using root_path --> setting it as our default page

  match '/signup', to: 'users#new' # call using signup_path

  match '/help', to: 'static_pages#help' # call using help_path
  match '/about', to: 'static_pages#about' # call using about_path
  match '/contact', to: 'static_pages#contact' # call using contact_path

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index' # ********************************************

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end