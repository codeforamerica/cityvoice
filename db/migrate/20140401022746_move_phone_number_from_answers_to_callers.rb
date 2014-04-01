class MovePhoneNumberFromAnswersToCallers < ActiveRecord::Migration
  def up
    Answer.all.each do |answer|
      caller = Caller.find_or_create_by!(phone_number: answer.phone_number)
      answer.update_column(:caller_id, caller.id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo answer migration"
  end
end
