class CreateVoiceFiles < ActiveRecord::Migration
  def change
    create_table :voice_files do |t|
      t.string :url

      t.timestamps
    end
  end
end
