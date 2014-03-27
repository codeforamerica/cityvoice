# == Schema Information
#
# Table name: feedback_inputs
#
#  id                 :integer          not null, primary key
#  question_id        :integer
#  subject_id         :integer
#  neighborhood_id    :integer
#  property_id        :integer
#  voice_file_url     :string(255)
#  numerical_response :integer
#  phone_number       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  call_source        :string(255)
#

class FeedbackInput < ActiveRecord::Base
  attr_protected
  belongs_to :subject, foreign_key: :property_id

  belongs_to :question
  belongs_to :property

  def self.total_calls
    where.not(numerical_response: nil).joins(:subject).group(:subject).count(:numerical_response)
  end

  def self.total_responses(numerical_response)
    where(numerical_response: numerical_response).joins(:subject).group(:subject).count(:numerical_response)
  end

  def self.voice_messages
    includes(:subject).where.not(voice_file_url: nil).order('created_at DESC')
  end
end
