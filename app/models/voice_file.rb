class VoiceFile < ActiveRecord::Base
  has_many :questions

  attr_accessible :short_name, :url

  validates_presence_of :short_name, :url
  validates_uniqueness_of :short_name
end
