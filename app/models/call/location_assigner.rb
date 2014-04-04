class Call::LocationAssigner < Struct.new(:call, :digits, :attempt_value)
  def first_attempt?
    attempt.first?
  end

  def next_attempt
    attempt.next
  end

  def assign
    unless attempt.first?
      if valid?
        call.update_attribute(:location, location)
      else
        attempt.validate!
      end
    end
  end

  def has_errors?
    !attempt.first? && !valid?
  end

  def valid?
    location.present?
  end

  protected

  def attempt
    @attempt ||= Call::Attempt.new(attempt_value)
  end

  def location
    @location ||= Location.find_by(id: digits)
  end
end
