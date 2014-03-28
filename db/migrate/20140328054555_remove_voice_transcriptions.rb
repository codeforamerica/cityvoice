class RemoveVoiceTranscriptions < ActiveRecord::Migration
  def up
    drop_table :voice_transcriptions
  end

  def down
    create_table :voice_transcriptions do |t|
      t.text :content

      t.timestamps
    end
  end
end
