Automidnight::Application.routes.draw do
  mount RailsEmailPreview::Engine, at: 'emails' if defined?(RailsEmailPreview::Engine)
  mount StyleGuide::Engine => '/style-guide' if defined?(StyleGuide::Engine)

  resources :voice_answers, only: [:index]
  resources :numerical_answers, only: [:index]
  get '/export' => 'numerical_answers#export'

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

  root to: 'landing#index'
end
