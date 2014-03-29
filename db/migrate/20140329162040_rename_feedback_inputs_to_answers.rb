class RenameFeedbackInputsToAnswers < ActiveRecord::Migration
  def change
    rename_table :feedback_inputs, :answers
  end
end
