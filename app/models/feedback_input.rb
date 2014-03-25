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
