# == Schema Information
#
# Table name: voice_files
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  short_name :string(255)
#

class VoiceFile < ActiveRecord::Base
  has_many :questions

  attr_accessible :short_name, :url

  validates_presence_of :short_name, :url
  validates_uniqueness_of :short_name
end
