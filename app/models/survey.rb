module Survey
  def self.questions_for
    Question.all.order(:updated_at)
  end
end
