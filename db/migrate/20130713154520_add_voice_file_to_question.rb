class AddVoiceFileToQuestion < ActiveRecord::Migration
  def change
    add_reference :questions, :voice_file
  end
end
