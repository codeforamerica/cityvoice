namespace :notifications do
  task send: :environment do
    SubscriberNotifier.send_weekly_notifications
  end
end
