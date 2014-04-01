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
      format.csv { send_data counts.to_csv }
    end
  end
end
