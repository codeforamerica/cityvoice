class RemoveVoiceFiles < ActiveRecord::Migration
  def up
    drop_table :voice_files
  end

  def down
    create_table :voice_files do |t|
      t.string :url
      t.string :short_name

      t.timestamps
    end
  end
end
