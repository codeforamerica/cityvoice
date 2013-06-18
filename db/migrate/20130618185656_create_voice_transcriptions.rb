class CreateVoiceTranscriptions < ActiveRecord::Migration
  def change
    create_table :voice_transcriptions do |t|
      t.text :content

      t.timestamps
    end
  end
end
