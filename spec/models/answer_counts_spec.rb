require 'spec_helper'

describe AnswerCounts do
  let(:location) { create(:location, name: '1313 Mockingbird Lane') }
  let(:call) { create(:call, location: location) }

  before do
    question = create(:question, :numerical_response, short_name: 'property_outcome')
    repair_choice = create(:choice, question: question, name: 'Repair', number: 1)
    create(:choice, question: question, name: 'Remove', number: 2)
    create(:answer, :numerical_response, call: call, question: question, choice: repair_choice)
  end

  subject(:counts) { AnswerCounts.new }

  its(:total_hash) { should == {location => {total: 1}} }
  its(:repair_hash) { should == {location => {repair: 1}} }
  its(:remove_hash) { should == {} }

  # its(:to_hash) { should == {location => {total: 1, repair: 1}} }
  # its(:to_array) { should == [[location, {:total=>1, :repair=>1}]] }
  # its(:to_csv) { should == "Address,Total,Repair,Remove\n1313 Mockingbird Lane,1,1,0\n" }
end
