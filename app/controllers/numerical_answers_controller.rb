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
      headers =  [ 'Time',
                   'Location',
                   'Source',
                   'Phone Number',
                 ]
      questions = Question.order(created_at: :asc)
      headers << questions.map(&:question_text)
      csv << headers.flatten

      Call.order(created_at: :desc).each do |c|
        columns = [ c.created_at,
                    c.location.name,
                    c.source,
                    c.caller.phone_number,
                  ]

        questions.map(&:id).each do |question_id|
          answer = c.answers.where(question_id: question_id).first
          columns << if answer.present?
                   if answer.numerical_response.to_s == "1"
                     "Yes"
                   elsif answer.numerical_response.to_s == "2"
                     "No"
                   else
                     answer.voice_file_url.to_s
                   end
                 end
        end

        csv << columns
      end
    end
  end
end
