require 'spec_helper'

describe FeedbackInputCounts do
  let(:property) { create :subject, name: '1313 Mockingbird Lane' }
  let!(:input) { create(:feedback_input, subject: property, numerical_response: '1') }

  let(:total_counts) { FeedbackInput.total_calls }
  let(:repair_counts) { FeedbackInput.total_responses(1) }
  let(:remove_counts) { FeedbackInput.total_responses(2) }

  subject(:counts) { FeedbackInputCounts.new(total_counts, repair_counts, remove_counts) }

  its(:total_hash) { should == {'1313 Mockingbird Lane' => {total: 1}} }
  its(:repair_hash) { should == {'1313 Mockingbird Lane' => {repair: 1}} }
  its(:remove_hash) { should == {} }

  its(:to_hash) { should == {'1313 Mockingbird Lane' => {total: 1, repair: 1}} }
  its(:to_array) { should == [['1313 Mockingbird Lane', {:total=>1, :repair=>1}]] }
  its(:to_csv) { should == "Address,Total,Repair,Remove\n1313 Mockingbird Lane,1,1,0\n" }
end
