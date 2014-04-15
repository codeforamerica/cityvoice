class Call::AnswerPlayer < Struct.new(:call, :digits, :answer_index, :attempt_value)
  CHOICES = {
    '1' => :continue,
    '2' => :stop,
  }

  def first_attempt?
    attempt.first?
  end

  def next_attempt
    attempt.next
  end

  def has_errors?
    !attempt.first? && !valid?
  end

  def valid?
    !choice.nil?
  end

  def continued?
    attempt.validate! unless valid?
    choice == :continue
  end

  def stopped?
    attempt.validate! unless valid?
    choice == :stop
  end

  def empty?
    scope_iterator.empty?
  end

  def has_reached_last_answer?
    !scope_iterator.has_more?
  end

  def answer
    scope_iterator.current
  end

  def next_answer_index
    scope_iterator.next_index
  end

  protected

  def choice
    CHOICES[digits.to_s]
  end

  def attempt
    @attempt ||= Call::Attempt.new(attempt_value)
  end

  def answers
    @answers ||= call.location.answers.voice_messages
  end

  def scope_iterator
    @scope_iterator ||= Call::ScopeIterator.new(answers, answer_index)
  end
end
