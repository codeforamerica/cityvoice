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
  it "properly associates Questions with VoiceFiles" do
    Question.all.each do |q|
      q.voice_file.should eq(VoiceFile.find_by_short_name(q.short_name))
    end
  end
end
