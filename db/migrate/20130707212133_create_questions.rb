class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :voice_text
      t.string :short_name
      t.string :feedback_type
      t.string :question_text

      t.timestamps
    end
  end
end
