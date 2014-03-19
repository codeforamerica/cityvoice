require 'spec_helper'

describe ImporterErrors do
  let(:errors) { double(:errors, full_messages: ['not enough tacos']) }
  let(:invalid) { double(:record, valid?: false, errors: errors) }

  subject(:importer_errors) { ImporterErrors.new(invalid, 6) }

  its(:line_number) { should == 6 }
  its(:message) { should == 'Line 6: not enough tacos' }

  describe '.messages_for' do
    let(:valid) { double(:record, valid?: true) }

    it 'collects the messages for all records by order of appearance' do
      messages = ImporterErrors.messages_for([valid, invalid])
      messages.should == ['Line 3: not enough tacos']
    end
  end
end
