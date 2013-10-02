Automidnight::Application.routes.draw do

  get "notification_subscriptions/confirm"
  get "notification_subscriptions/unsubscribe"

  # Comment out resource route for now; eventually use
  #resources :app_content_sets

  get "/" => "landing#location_search"

  resources :notification_subscriptions, only: [:create]

  #resources :questions

  #resources :feedback_inputs

  resources :subjects, :only => [:index, :show]

  #resources :voice_transcriptions

  #get 'properties/:address' => 'subjects#property_address'

  get 'voice-messages', to: 'feedback_inputs#voice_messages', as: :voice_messages

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #post '/sms' => 'text_feedback#handle_feedback'
  #post '/' => 'voice_transcriptions#ask_for_response'
  #post '/voice' => 'voice_feedback#splash_message'
  #post '/respond_to_property_code' => 'voice_feedback#respond_to_property_code'
  #post '/solicit_comment' => 'voice_feedback#solicit_comment'

  post '/route_to_survey' => 'voice_feedback#route_to_survey'
  post '/listen_to_messages_prompt' => 'voice_feedback#listen_to_messages_prompt'
  post '/check_for_messages' => 'voice_feedback#check_for_messages'
  post '/consent' => 'voice_feedback#consent'
  post '/voice_survey' => 'voice_feedback#voice_survey'

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
