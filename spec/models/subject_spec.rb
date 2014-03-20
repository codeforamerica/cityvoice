require 'spec_helper'

describe Subject do
  it { should belong_to :neighborhood }
  it { should validate_presence_of :name }
end
