class Call::QuestionAnswerer < Struct.new(:call, :question_index, :attempt_value)
  attr_accessor :last_digits

  def answer_question(params)
    self.last_digits = params['Digits']
    return unless has_question?
    answer = question.answer(call, params)
    attempt.validate! unless valid?
    answer.valid?
  end

  def first_attempt?
    attempt.first?
  end

  def next_attempt
    repeat? ? attempt.current : attempt.next
  end

  def has_errors?
    !attempt.first? && !valid?
  end

  def valid?
    question.answers.where(call: call).count > 0
  end

  def repeat?
    self.last_digits == '#'
  end

  def empty?
    scope_iterator.empty?
  end

  def has_reached_last_question?
    !scope_iterator.has_more?
  end

  def question
    scope_iterator.current
  end

  def next_question_index
    scope_iterator.next_index
  end

  def has_question?
    question.present?
  end

  protected

  def attempt
    @attempt ||= Call::Attempt.new(attempt_value)
  end

  def questions
    Question.all.order(updated_at: :asc)
  end

  def scope_iterator
    @scope_iterator ||= Call::ScopeIterator.new(questions, question_index)
  end
end
