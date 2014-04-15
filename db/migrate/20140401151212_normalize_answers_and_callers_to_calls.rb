class NormalizeAnswersAndCallersToCalls < ActiveRecord::Migration
  def up
    add_column :answers, :call_id, :integer

    Answer.all.each do |answer|
      caller = Caller.find_or_create_by(phone_number: answer.phone_number)
      location = Location.find(answer.location_id)
      call = Call.find_or_create_by(caller: caller, location: location)
      call.update_attribute(:source, answer.call_source)
      call.update_attribute(:consented_to_callback, caller.consented_to_callback)
      answer.update_column(:call_id, call.id)
    end

    remove_columns :answers, :location_id, :call_source, :phone_number
    remove_columns :callers, :consented_to_callback
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo normalization migration"
  end
end
