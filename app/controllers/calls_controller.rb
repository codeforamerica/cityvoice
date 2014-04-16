class CallsController < TwilioController
  def create
    caller = Caller.find_or_create_by(phone_number: params['From'])
    @call = caller.calls.create!(source: params['To'])
  end
end
