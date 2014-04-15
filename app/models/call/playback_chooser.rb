class Call::PlaybackChooser < Struct.new(:call, :digits, :attempt_value)
  CHOICES = {
    '1' => :playback,
    '2' => :consent,
  }

  def next_attempt
    attempt.next
  end

  def has_errors?
    !attempt.first? && !valid?
  end

  def valid?
    !choice.nil?
  end

  def playback?
    attempt.validate! unless valid?
    choice == :playback
  end

  def consent?
    attempt.validate! unless valid?
    choice == :consent
  end

  protected

  def attempt
    @attempt ||= Call::Attempt.new(attempt_value)
  end

  def choice
    CHOICES[digits.to_s]
  end
end
