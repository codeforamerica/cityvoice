class Subject < ActiveRecord::Base
  attr_protected
  validates :name, presence: true

  def property_code
    digits = content_set.call_in_code_digits.to_i
    self.id.to_s.rjust(digits, '0')
  end

  protected

  def content_set
    Rails.application.config.app_content_set
  end
end
