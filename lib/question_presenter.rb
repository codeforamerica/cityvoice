class QuestionPresenter < Struct.new(:row)
  def valid?
    to_question.valid?
  end

  def to_question
    question = Question.find_or_initialize_by(short_name: row[:short_name])
    question.attributes = row
    question
  end
end
