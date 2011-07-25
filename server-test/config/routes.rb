SnaTest::Application.routes.draw do
  resources :messages

  resources :person_relations

  resources :people

  match 'api/data/' => 'api#get_data', :via => :get

  match 'api/profile/' => 'api#register_profile', :via => :post
  
  match 'api/profile/' => 'api#update_profile', :via => :get

  match 'people/:id/friends' => 'people#friends', :as => :person_friends

  match 'people/:id/relations/:id2/remove' => 'people#remove_relation', :as => :remove_relation

  match 'people/:id/relations/:id2/add_friend' => 'people#add_friend', :as => :add_friend

  match 'people/:id/relations/:id2/add_waiting_for_him' => 'people#add_waiting_for_him', :as => :add_waiting_for_him

  match 'people/:id/relations/:id2/add_waiting_for_me' => 'people#add_waiting_for_me', :as => :add_waiting_for_me

  match 'people/:id/relations/:id2/add_rejected' => 'people#add_rejected', :as => :add_rejected


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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
