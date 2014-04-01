class AddCallerIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :caller_id, :integer
  end
end
