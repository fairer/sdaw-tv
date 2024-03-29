ActionController::Routing::Routes.draw do |map|
  map.resources :chats
  map.resources :posts, :has_many => :comments
  map.resources :episodes

  map.connect 'plannings/get_ad.:format', :controller => 'plannings', :action => 'get_ad'
  map.connect 'plannings/now.:format', :controller => 'plannings', :action => 'now'
  map.connect 'plannings/clean', :controller => 'plannings', :action => 'clean'
  map.connect 'plannings/test', :controller => 'plannings', :action => 'test'
  map.resources :plannings
  map.connect 'planning/:action', :controller => 'plannings'
  map.resources :videos
  map.resources :posts, :has_many => :comments
  map.resources :comments, :belongs_to => :posts
  map.add_episode 'videos/:id/add_episode', :controller => 'videos', :action => 'add_episode'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.root :controller => 'home'

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action.:format'
  map.connect ':controller/:action/:id.:format'

end
