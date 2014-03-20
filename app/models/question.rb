class Question < ActiveRecord::Base
  belongs_to :voice_file

  attr_protected
end
