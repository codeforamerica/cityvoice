# == Schema Information
#
# Table name: choices
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  number      :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Choice < ActiveRecord::Base
  belongs_to :question
  has_many :answers

  attr_accessible :name, :number, :question
end
