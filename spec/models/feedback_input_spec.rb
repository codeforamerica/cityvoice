require 'spec_helper'

describe FeedbackInput do
  it { should belong_to(:subject) }
  it { should belong_to(:property) }
  it { should belong_to(:question) }
end
