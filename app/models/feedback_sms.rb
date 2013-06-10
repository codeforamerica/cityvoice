class FeedbackSms

  attr_reader :text

  def initialize(request_params)
    @text = request_params["Body"]
  end

  def address
    "1234 Lincoln Way West"
  end

  def valid?
    /\d{4}[DROdro0]/.match @text
  end

end

