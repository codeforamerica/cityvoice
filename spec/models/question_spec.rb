require 'spec_helper'

describe Question do
  it { should belong_to :voice_file }
end
