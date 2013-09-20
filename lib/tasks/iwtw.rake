namespace :iwtw do

  desc "Creates (or updates) target storefronts"
  task :load_storefronts => :environment do
    raise "Uh oh! >4 subjects!" if Subject.count > 4
    s1 = Subject.find_or_create_by(name: "237 N Michigan (former LaSalle Hotel)")
    s1.update_attributes(:lat => "41.678013", :long => "-86.250477")
    s2 = Subject.find_or_create_by(name: "13 S Michigan")
    s2.update_attributes(:lat => "41.676364", :long => "-86.250375")
    s3 = Subject.find_or_create_by(name: "225 N Michigan")
    s3.update_attributes(:lat => "41.677920", :long => "-86.250461")
    #s3 = Subject.find_or_create_by(name: "")
    #s4.update_attributes(:lat => "", :long => "")
  end

  desc "Adds (or updates) voice files for IWTW"
  task voice_files: :environment do
    def s3_path_for(filename)
      "https://s3-us-west-1.amazonaws.com/south-bend-cityvoice-iwtw/#{filename}.mp3"
    end
    # May want to include error messages here
    ["welcome", "code_input", "i_wish_comment", "thanks"].each do |short_name|
      vf = VoiceFile.find_or_create_by(short_name: short_name)
      vf.update_attribute(:url, s3_path_for(short_name))
    end
  end

  desc "Adds (or updates) questions for IWTW"
  task questions: :environment do
    q = Question.find_or_create_by(:short_name => "i_wish_comment")
    q.update_attributes(:feedback_type => "voice_file", :voice_file_id => VoiceFile.find_by_short_name(q.short_name))
  end

end

