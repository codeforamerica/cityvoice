class TextReply
  attr_reader :body
  def initialize(reply_text)
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms reply_text
    end
    @body = twiml.text
  end
end

