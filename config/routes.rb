DruggableGene::Application.routes.draw do
  get 'drug_claims/:source_db_name/:name' => 'drug_claims#show',
    constraints: { name: /[^\/]+/ }
  get 'gene_claims/:source_db_name/:name' => 'gene_claims#show'
  get 'gene_names' => 'genes#names'
  # add a drug_names thing here, so that they can be pulled via json?
  get 'drug_names' => 'drugs#names'
  get 'genes/:name' => 'genes#show', as: 'gene'
  get 'interaction_claims/:id' => 'interaction_claims#show', as: 'interaction_claims'
  get 'druggable_gene_categories/:name' => 'genes#druggable_gene_category', as: 'gene_by_category'
  get 'druggable_gene_categories' => 'genes#druggable_gene_categories'
  get 'drugs/:name' => 'drugs#show', as: 'drug', name: /.*/
  get 'sources/:source_db_name' => 'sources#show', as: 'source'
  get 'sources' => 'sources#sources'
  # get 'drugs/:name/related' => 'drugs#related_drugs', as: 'related_drug'
  get 'search_results' => 'search#search_results'
  get 'cache/invalidate' => 'utilities#invalidate_cache'
  post  'download_table' => 'utilities#download_request_content'
  post  'api/v1/interactions' => 'services_v1#interactions'
  post  'api/v1/related_genes' => 'services_v1#related_genes'
  get   'api/v1/:action' => 'services_v1#:action'
  get 'interaction_search_results/:name' => 'interaction_claims#interaction_search_results', name: /.*[^#]/
  get 'interaction_search_results' => 'interaction_claims#interaction_search_results'
  get 'interactions_for_related_genes' => 'interaction_claims#interactions_for_related_genes'
  get 'categories_search_results' => 'genes#categories_search_results'
  get ':action' => 'static#:action'
  root :to => 'static#search_interactions'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id))(.:format)'
end
