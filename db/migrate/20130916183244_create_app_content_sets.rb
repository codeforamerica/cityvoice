class CreateAppContentSets < ActiveRecord::Migration
  def change
    create_table :app_content_sets do |t|
      t.string :issue
      t.string :learn_text
      t.string :call_text
      t.string :call_instruction
      t.string :app_phone_number
      t.string :listen_text
      t.string :message_from
      t.string :message_url

      t.timestamps
    end
  end
end
