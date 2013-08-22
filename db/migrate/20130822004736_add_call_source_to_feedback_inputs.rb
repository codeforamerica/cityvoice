class AddCallSourceToFeedbackInputs < ActiveRecord::Migration
  def change
    add_column :feedback_inputs, :call_source, :string
  end
end
