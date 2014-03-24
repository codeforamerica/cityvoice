class AppContentSet < ActiveRecord::Base
  attr_accessible :call_in_code_digits, :issue, :feedback_form_url

  validates_length_of :call_in_code_digits, is: 1

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
