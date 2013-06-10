class FeedbackSms

  attr_reader :text

  def initialize(request_params)
    @text = request_params["Body"]
  end

  def address
    "1234 Lincoln Way West"
  end

end

