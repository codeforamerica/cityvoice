class VoiceFile < ActiveRecord::Base
  has_many :questions
  attr_accessible :url, :short_name
end
