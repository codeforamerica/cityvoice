class AddShortNameToVoiceFile < ActiveRecord::Migration
  def change
    add_column :voice_files, :short_name, :string
  end
end
