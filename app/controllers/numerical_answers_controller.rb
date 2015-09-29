class NumericalAnswersController < ApplicationController
  def index
    total_counts = Answer.total_calls
    agree_counts = Answer.total_responses(1)
    disagree_counts = Answer.total_responses(2)
    counts = AnswerCounts.new(total_counts, agree_counts, disagree_counts)
    @questions = Question.numerical
    @counts_hash = counts.to_hash
    @sorted_array = counts.to_array
    respond_to do |format|
      format.html
      format.csv { send_data counts.to_csv }
    end
  end

  def export
    data_table = Array.new
    header_row = Array.new
    header_row << "Call ID"
    header_row << "Location"
    numerical_questions = Question.numerical.order(:id)
    numerical_questions.each do |question|
      header_row << question.question_text
    end
    voice_questions = Question.where(feedback_type: "voice_file")
    voice_questions.each do |question|
      header_row << question.question_text
    end
    data_table << header_row
    calls = Call.where.not(location_id: nil).order(:id)
    calls.each do |call|
      call_array = Array.new
      call_array << call.id
      call_array << call.location.name
      answers = call.answers
      numerical_questions.each do |question|
        answer_results = answers.select { |a| a.question_id == question.id }
        if answer_results.count == 0
          call_array << ""
        elsif answer_results.count == 1
          numerical_response = answer_results[0].numerical_response
          if numerical_response == 1
            call_array << "Agree"
          elsif numerical_response == 2
            call_array << "Disagree"
          else
            call_array << ""
          end
        else
          raise "Uh oh, more than one result"
        end
      end
      voice_questions.each do |question|
        answer_results = answers.select { |a| a.question_id == question.id }
        if answer_results.count == 1
          call_array << answer_results[0].voice_file_url
        else
          call_array << ""
        end
      end
      data_table << call_array
    end
    respond_to do |format|
      format.csv {
        csv_string = CSV.generate do |csv|
          data_table.each do |row|
            csv << row
          end
        end
        send_data csv_string
      }
    end
  end
end
