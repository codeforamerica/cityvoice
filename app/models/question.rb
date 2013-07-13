class Question < ActiveRecord::Base
  attr_protected
  def voice_file
    VoiceFile.find(voice_file_id)
  end
end
