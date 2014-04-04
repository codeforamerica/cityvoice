Automidnight::Application.routes.draw do
  mount RailsEmailPreview::Engine, at: 'emails' if defined?(RailsEmailPreview::Engine)

  resources :voice_answers, only: [:index]
  resources :numerical_answers, only: [:index]

  resource :subscription, controller: :subscription, only: [:create] do
    resource :confirm, module: :subscription, only: [:show]
    resource :unsubscribe, module: :subscription, only: [:show]
  end

  get '/.well-known/status' => 'status#check'

  resources :locations, only: [:index, :show]

  resources :calls, only: [:create] do
    scope module: :calls do
      resource :location, only: [:create]
      resources :messages, only: [:create] do
        resource :playback, only: [:create]
      end
      resource :consent, only: [:create]
      resources :questions, only: [:create] do
        resource :answer, only: [:create]
      end
    end
  end

  post '/check_for_messages' => 'voice_feedback#check_for_messages'
  post '/consent' => 'voice_feedback#consent'
  post '/listen_to_messages_prompt' => 'voice_feedback#listen_to_messages_prompt'
  post '/message_playback' => 'voice_feedback#message_playback'
  post '/route_to_survey' => 'voice_feedback#route_to_survey'
  post '/voice_survey' => 'voice_feedback#voice_survey'

  root to: 'landing#index'
end
