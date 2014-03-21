class DropVoiceTextFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :voice_text
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover deleted voice text"
  end
end
