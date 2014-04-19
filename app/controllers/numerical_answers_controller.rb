class NumericalAnswersController < ApplicationController
  def index
    counts = AnswerCounts.new
    @counts_hash = counts.to_hash
    @sorted_array = counts.to_array
    respond_to do |format|
      format.html
      format.csv { send_data counts.to_csv }
    end
  end
end
