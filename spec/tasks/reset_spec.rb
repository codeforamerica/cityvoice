require 'spec_helper'
require 'rake'
Automidnight::Application.load_tasks

describe "Reset Task" do
  before(:all) do
    Rake::Task['reset:voice_files'].invoke
    Rake::Task['reset:questions'].invoke
  end
  it "creates Questions" do
    Question.count.should_not eq(0)
  end
end
