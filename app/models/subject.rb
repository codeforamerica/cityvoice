class Subject < ActiveRecord::Base
  attr_protected
  belongs_to :neighborhood
end
