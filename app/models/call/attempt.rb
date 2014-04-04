class Call::Attempt < Struct.new(:attempt)
  def validate!
    raise TwilioSessionError.new(:fatal_error) if last?
  end

  def next
    current + 1
  end

  def first?
    current == 0
  end

  def current
    attempt.to_i || 0
  end

  def last?
    current >= 2
  end
end
