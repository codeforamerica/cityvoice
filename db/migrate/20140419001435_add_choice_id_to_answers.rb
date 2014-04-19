class AddChoiceIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :choice_id, :integer
  end
end
