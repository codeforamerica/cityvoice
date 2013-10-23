class FeedbackInputsController < ApplicationController
  before_action :set_feedback_input, only: [:show, :edit, :update, :destroy]

  # GET /feedback_inputs
  # GET /feedback_inputs.json
  def index
    @feedback_inputs = FeedbackInput.all
  end

  def most_feedback
    @total_counts = FeedbackInput.where.not(:numerical_response => nil).joins(:subject).group(:subject).count(:numerical_response)#.map { |item| { item[0].name => { :total => item[1] } } }
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

  # GET /feedback_inputs/1
  # GET /feedback_inputs/1.json
  def show
  end

  # GET /feedback_inputs/new
  def new
    @feedback_input = FeedbackInput.new
  end

  # GET /feedback_inputs/1/edit
  def edit
  end

  # POST /feedback_inputs
  # POST /feedback_inputs.json
  def create
    @feedback_input = FeedbackInput.new(feedback_input_params)

    respond_to do |format|
      if @feedback_input.save
        format.html { redirect_to @feedback_input, notice: 'Feedback input was successfully created.' }
        format.json { render action: 'show', status: :created, location: @feedback_input }
      else
        format.html { render action: 'new' }
        format.json { render json: @feedback_input.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedback_inputs/1
  # PATCH/PUT /feedback_inputs/1.json
  def update
    respond_to do |format|
      if @feedback_input.update(feedback_input_params)
        format.html { redirect_to @feedback_input, notice: 'Feedback input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feedback_input.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedback_inputs/1
  # DELETE /feedback_inputs/1.json
  def destroy
    @feedback_input.destroy
    respond_to do |format|
      format.html { redirect_to feedback_inputs_url }
      format.json { head :no_content }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback_input
      @feedback_input = FeedbackInput.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_input_params
      params.require(:feedback_input).permit(:question_id, :subject_id, :neighborhood_id, :property_id, :voice_file_url, :numberical_response)
    end
end
