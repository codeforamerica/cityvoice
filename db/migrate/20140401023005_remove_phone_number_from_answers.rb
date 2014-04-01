class RemovePhoneNumberFromAnswers < ActiveRecord::Migration
  def change
    remove_column(:answers, :phone_number, :string)
  end
end
