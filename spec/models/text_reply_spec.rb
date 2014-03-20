require 'spec_helper'

describe TextReply do
  subject(:text_reply) { TextReply.new("aren't tacos great?") }

  describe '#body' do
    it 'returns a twilio sms response' do
      expect(text_reply.body).to match_xpath('Response/Sms')
    end

    it 'responds with the text' do
      node = Nokogiri::XML::Document.parse(text_reply.body).xpath('Response/Sms')
      expect(node.text).to eq("aren't tacos great?")
    end
  end
end
