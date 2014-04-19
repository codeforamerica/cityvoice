class NormalizeAnswerNumericalResponse < ActiveRecord::Migration
  class Answer20140418172220 < ActiveRecord::Base
    self.table_name = :answers
  end

  class Choice20140418172220 < ActiveRecord::Base
    self.table_name = :choices
    attr_accessible :name, :number, :question_id
  end

  def up
    Answer20140418172220.all.each do |answer|
      choice = Choice20140418172220.find_or_create_by!(
        name: "Number #{answer.numerical_response}",
        number: answer.numerical_response,
        question_id: answer.question_id
      )
      answer.update_column(:choice_id, choice.id)
    end

    remove_column :answers, :numerical_response
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo normalization migration"
  end
end
