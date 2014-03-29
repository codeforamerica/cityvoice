class RemoveVoiceFileIdFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :voice_file_id
  end

  def down
    add_column :questions, :integer, :voice_file_id
  end
end
