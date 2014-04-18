require 'spec_helper'

describe AnswerCounts do
  let(:location) { create(:location, name: '1313 Mockingbird Lane') }
  let(:call) { create(:call, location: location) }
  let!(:input) { create(:answer, call: call, numerical_response: '1') }

  let(:total_counts) { Answer.total_calls }
  let(:repair_counts) { Answer.total_responses(1) }
  let(:remove_counts) { Answer.total_responses(2) }

  subject(:counts) { AnswerCounts.new(total_counts, repair_counts, remove_counts) }

  its(:total_hash) { should == {location => {total: 1}} }
  its(:repair_hash) { should == {location => {repair: 1}} }
  its(:remove_hash) { should == {} }

  its(:to_hash) { should == {location => {total: 1, repair: 1}} }
  its(:to_array) { should == [[location, {:total=>1, :repair=>1}]] }
  its(:to_csv) { should == "Address,Total,Repair,Remove\n1313 Mockingbird Lane,1,1,0\n" }
end
