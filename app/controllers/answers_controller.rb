class AnswersController < ApplicationController
  def most_feedback
    total_counts = Answer.total_calls
    repair_counts = Answer.total_responses(1)
    remove_counts = Answer.total_responses(2)
    counts = AnswerCounts.new(total_counts, repair_counts, remove_counts)
    @counts_hash = counts.to_hash
    @sorted_array = counts.to_array
    respond_to do |format|
      format.html { render :most_feedback }
      format.csv { send_data counts.to_csv }
    end
  end

  def voice_messages
    @messages = Answer.voice_messages

    if params[:all].nil?
      @messages = @messages.paginate(page: params[:page], per_page: 10)
    end
  end
end
