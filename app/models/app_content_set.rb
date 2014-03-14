# == Schema Information
#
# Table name: app_content_sets
#
#  id                  :integer          not null, primary key
#  issue               :string(255)
#  learn_text          :text
#  call_text           :string(255)
#  call_instruction    :string(255)
#  app_phone_number    :string(255)
#  listen_text         :string(255)
#  message_from        :string(255)
#  message_url         :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  header_color        :string(255)
#  short_title         :string(255)
#  call_in_code_digits :string(1)
#  feedback_form_url   :string(255)
#

class AppContentSet < ActiveRecord::Base
  def self.configure_contents
    raise "Error: more than one instance of app content!" if self.count > 1
    if AppContentSet.count == 1
      app_content = AppContentSet.first
    else
      app_content = AppContentSet.new
    end
    yield app_content
    app_content.save
    app_content
  end
end
