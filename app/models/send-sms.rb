require 'twilio-ruby'

account_sid = "ACxxxxxxxxxxxxxxxxxxxxxxxx"
auth_token = "yyyyyyyyyyyyyyyyyyyyyyyyy"
client = Twilio::REST::Client.new account_sid, auth_token
 
from = "+15024985706" # Your Twilio number
 
friends = {
"+14153334444" => "Curious George",
"+14155557775" => "Boots",
"+14155551234" => "Virgil"
}
friends.each do |key, value|
  client.account.messages.create(
    :from => from,
    :to => key,
    :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
  )
  puts "Sent message to #{value}"
end