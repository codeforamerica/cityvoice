class FeedbackInputsController < ApplicationController
  before_action :set_feedback_input, only: [:show, :edit, :update, :destroy]

  # GET /feedback_inputs
  # GET /feedback_inputs.json
  def index
    @feedback_inputs = FeedbackInput.all
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
