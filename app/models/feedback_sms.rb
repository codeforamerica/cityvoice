class FeedbackSms

  attr_reader :text

  @@code_hash = { "D" => "Demolish", "R" => "Rehab", "O" => "Other", "d" => "Demolish", "r" => "Rehab", "o" => "Other", "0" => "Other" }

  def initialize(request_params)
    @text = request_params["Body"]
  end

  def address
    "1234 Lincoln Way West"
  end

  def choice_selected
    @@code_hash[@text[4]]
  end

  def valid?
    /\d{4}[DROdro0]/.match @text
  end

end

