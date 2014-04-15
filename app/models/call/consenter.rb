class Call::Consenter < Struct.new(:call, :digits, :attempt_value)
  CHOICES = {
    '1' => true,
    '2' => false,
  }

  def next_attempt
    attempt.next
  end

  def consent
    unless attempt.first?
      if valid?
        call.update_attribute(:consented_to_callback, choice)
      else
        attempt.validate!
      end
    end
  end

  def has_errors?
    !attempt.first? && !valid?
  end

  def valid?
    !choice.nil?
  end

  protected

  def attempt
    @attempt ||= Call::Attempt.new(attempt_value)
  end

  def choice
    CHOICES[digits.to_s]
  end
end
