if Rails.env.production? && ENV['GOOGLE_ANALYTICS_ON'] == "true"
  GA.tracker = 'UA-43486781-1'
end
