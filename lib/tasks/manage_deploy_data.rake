namespace :manage_deploy_data do

  namespace :abandoned_properties do

    desc "Resets voice files"
    task voice_files: :environment do
      def s3_path_for(filename)
        "https://s3.amazonaws.com/south-bend-cityvoice-abandoneds/v5/#{filename}.mp3"
      end
      ["property_comments", "property_outcome", "thanks", "welcome", "code_prompt", "error1", "error2", "consent", "listen_to_messages_prompt", "no_feedback_yet", "listen_to_another", "last_message_reached"].each do |short_name|
        vf = VoiceFile.find_or_create_by(short_name: short_name)
        vf.update_attribute(:url, s3_path_for(short_name))
      end
    end

    desc "Resets the Questions table with the correct questions"
    task questions: :environment do
      prop_outcome = Question.find_or_create_by(:short_name => "property_outcome")
      prop_outcome.update_attributes(feedback_type: "numerical_response")
      prop_comments = Question.find_or_create_by(:short_name => "property_comments")
      prop_comments.update_attributes(feedback_type: "voice_file")
      Question.all.each do |question|
        question.update_attribute(:voice_file_id, VoiceFile.find_by_short_name(question.short_name).id)
      end
    end

    task :remove_neighborhood_questions => :environment do
      ["public_safety", "property_values", "neighborhood_comments"].each do |short_name|
        q = Question.find_by_short_name(short_name)
        q.destroy if q
      end
    end

    task :replace_voice_files => :environment do
      filenames = %w(RE2687363f93b3e54ac6fbf617984ebf27 \
        RE31d35440d5048be9e8d79f3dc703298a \
        RE360a8f58278ac0aba6009e854bfbd2ae \
        RE49411d6895e5f5c57010985406518670 \
        RE49f3dccc87b1ac6a41799632531e1e9d \
        RE52c2e2d4ee3a6e54d2042a885f811903 \
        RE5302724ea9cce221cbbb8c4190815572 \
        RE568100e0aa9334ab5ad3797d0b8f7276 \
        RE6414f6cf32f51412b480366642e0a036 \
        RE64f51402e34345e9815a4dd6ec1fee0a \
        RE6e53aa8a2f87fa7f0e2b4311848b5edb \
        RE6e759e973ee6757a9c701f61f4c315b6 \
        RE71ed861815b7b28f3b435073ef0cb952 \
        RE73a42d00e4528b2c1e4806f409f490e4 \
        RE795845a924ed1a1bed8dd493bdd1d83e \
        RE7b3b23b512a8d811d73a5fd0545f0b0f \
        RE8d279d467d814607aa5dc7d1b50146a6 \
        RE9998f7ebea56907ce158289454465140 \
        REae3152621376b255e04cc0ab0169e4bd \
        REdc7ab17f0589911b8d741705df6aa2f1 \
        REfa3948da145f7c393e04e1c55edaa1f5).select { |e| e != "\n" }
      filenames.each do |filename|
        target_fi_set = FeedbackInput.where("voice_file_url like ?", "%#{filename}")
        if target_fi_set.count > 1
          p "ERROR: More than one voice file found for #{filename}"
        elsif target_fi_set.count == 0
          p "ERROR: #{filename} not found"
        else
          target_fi = target_fi_set[0]
          p "Replacing #{target_fi.voice_file_url}"
          target_fi.update_attribute(:voice_file_url, "https://s3.amazonaws.com/south-bend-cityvoice-abandoneds/modified-voice-files/#{filename}")
        end
      end
    end
  end # namespace: abandoned_properties


  namespace :iwtw do

    desc "Adds (or updates) voice files for IWTW"
    task voice_files: :environment do
      def s3_path_for(filename)
        "https://s3.amazonaws.com/south-bend-cityvoice-iwtw/#{filename}.mp3"
      end
      # May want to include error messages here
      ["welcome", "code_prompt", "i_wish_comment", "thanks"].each do |short_name|
        vf = VoiceFile.find_or_create_by(short_name: short_name)
        vf.update_attribute(:url, s3_path_for(short_name))
      end
    end

    desc "Adds (or updates) questions for IWTW"
    task questions: :environment do
      q = Question.find_or_create_by(:short_name => "i_wish_comment")
      q.update_attributes(:feedback_type => "voice_file", :voice_file_id => VoiceFile.find_by_short_name(q.short_name).id)
    end

    desc "Creates (or updates) target storefronts"
    task :load_storefronts => :environment do
      raise "Uh oh! >4 subjects!" if Subject.count > 4
      s1 = Subject.find_or_create_by(name: "237 N Michigan (former LaSalle Hotel)")
      s1.update_attributes(:lat => "41.678013", :long => "-86.250477", :property_code => "10")
      s2 = Subject.find_or_create_by(name: "132 S Michigan")
      s2.update_attributes(:lat => "41.675934", :long => "-86.250326", :property_code => "11")
      s3 = Subject.find_or_create_by(name: "225 S Michigan (Left Storefront)")
      s3.update_attributes(:lat => "41.674697", :long => "-86.250334", :property_code => "12")
      s4 = Subject.find_or_create_by(name: "225 S Michigan (Right Storefront)")
      s4.update_attributes(:lat => "41.674697", :long => "-86.250034", :property_code => "13")
    end
  end # namespace: iwtw

  namespace :example do
    desc "Adds example subjects"
    task :subjects => :environment do
      content_path = Rails.root.join('data/subjects.csv.example')
      importer = SubjectImporter.import_file(content_path)
      unless importer.valid?
        importer.errors.each do |error|
          puts error
        end
      end
    end

    desc "Adds example questions"
    task :questions => :environment do
      content_path = Rails.root.join('data/questions.csv.example')
      importer = QuestionImporter.import_file(content_path)
      unless importer.valid?
        importer.errors.each do |error|
          puts error
        end
      end
    end
  end

end
