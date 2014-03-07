Automidnight::Application.routes.draw do
  get 'feedback', to: 'feedback_inputs#most_feedback', as: :most_feedback
  get 'voice-messages', to: 'feedback_inputs#voice_messages', as: :voice_messages

  get '/' => 'landing#location_search'

  resources :notification_subscriptions, only: [:create]
  get 'notification_subscriptions/confirm'
  get 'notification_subscriptions/unsubscribe'

  get '/.well-known/status' => 'status#check'

  resources :subjects, only: [:index, :show]

  post '/check_for_messages' => 'voice_feedback#check_for_messages'
  post '/consent' => 'voice_feedback#consent'
  post '/listen_to_messages_prompt' => 'voice_feedback#listen_to_messages_prompt'
  post '/message_playback' => 'voice_feedback#message_playback'
  post '/route_to_survey' => 'voice_feedback#route_to_survey'
  post '/voice_survey' => 'voice_feedback#voice_survey'
end
