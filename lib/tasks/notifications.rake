namespace :notifications do
  task :send => :environment do
    Notifier.send_weekly_notifications
  end
end
