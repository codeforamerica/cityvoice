class FeedbackInputsController < ApplicationController
  def most_feedback
    @total_counts = FeedbackInput.where.not(:numerical_response => nil).joins(:subject).group(:subject).count(:numerical_response)
    @repair_counts = FeedbackInput.where(:numerical_response => 1).joins(:subject).group(:subject).count(:numerical_response)
    @remove_counts = FeedbackInput.where(:numerical_response => 2).joins(:subject).group(:subject).count(:numerical_response)
    @counts_hash = Hash.new
    @total_counts.each { |tc| @counts_hash[tc[0].name] = { :total => tc[1] } }
    @repair_counts.each { |rc| @counts_hash[rc[0].name][:repair] = rc[1] }
    @remove_counts.each { |rc| @counts_hash[rc[0].name][:remove] = rc[1] }
    @counts_array = Array.new
    @counts_hash.each { |elem| @counts_array << elem }
    @sorted_array = @counts_array.sort_by { |elem| elem[1][:total].to_i }.reverse
    respond_to do |format|
      format.html { render 'most_feedback' }
      format.csv do
        require 'csv'
        csv_output = CSV.generate do |csv|
          csv << ["Address", "Total", "Repair", "Remove"]
          @sorted_array.each do |element|
            csv << [element[0], element[1].fetch(:total) { 0 }, element[1].fetch(:repair) { 0 }, element[1].fetch(:remove) { 0 }]
          end
        end
        send_data csv_output
      end
    end
  end

  # /messages
  def voice_messages
    if params[:all] == nil
      @messages = FeedbackInput.includes(:subject)
                               .where.not(:voice_file_url => nil)
                               .order("created_at DESC")
                               .paginate(page: params['page'], per_page: 10)
    else
      @messages = FeedbackInput.includes(:subject)
                               .where.not(:voice_file_url => nil)
                               .order("created_at DESC")
    end
  end
end
