class NumericalAnswersController < ApplicationController
  def index
    total_counts = Answer.total_calls
    repair_counts = Answer.total_responses(1)
    remove_counts = Answer.total_responses(2)
    counts = AnswerCounts.new(total_counts, repair_counts, remove_counts)
    @counts_hash = counts.to_hash
    @sorted_array = counts.to_array
    respond_to do |format|
      format.html
      format.csv { send_data build_csv }
    end
  end

  private
  
  def build_csv
    CSV.generate do |csv|
      csv << [ 'Time',
         'Location',
         'Source',
         'Phone Number',
         'Question Prompt',
         'Response'
             ]
      Answer.all.each do |a|
        csv << [ a.created_at,
                 a.call.location.name,
                 a.call.source,
                 a.call.caller.phone_number,
                 a.question.question_text,
                 (a.numerical_response || a.voice_file_url)
               ]
      end
    end
  end
end
