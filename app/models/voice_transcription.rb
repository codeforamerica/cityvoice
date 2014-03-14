# == Schema Information
#
# Table name: voice_transcriptions
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class VoiceTranscription < ActiveRecord::Base
  attr_protected
end
