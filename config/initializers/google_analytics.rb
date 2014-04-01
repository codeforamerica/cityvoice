if Rails.env.production? && ENV['GOOGLE_ANALYTICS_ID'].present?
  GA.tracker = ENV['GOOGLE_ANALYTICS_ID']
end
