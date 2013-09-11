class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

  def property_address
    @clean_address = params[:address].gsub("-", " ")
    params[:id] = Subject.find_by_name(@clean_address).id
    show
    render :show
  end

  # GET /subjects
  # GET /subjects.json
  def index
    @subjects = Subject.all
  end

  # GET /subjects/1
  # GET /subjects/1.json
  def show
    #public_safety_question = Question.find_by_short_name("public_safety")
    #prop_value_question = Question.find_by_short_name("property_values")
    @subject = Subject.find(params[:id])
    if @subject.type == "Neighborhood"
      @questions_raw = Question.where(:short_name => ["public_safety", "property_values"])
      @questions = Array.new
      @questions_raw.each do |q|
        average_priority = FeedbackInput.where(:neighborhood_id => params[:id], :question_id => q.id).average("numerical_response")
        @questions << OpenStruct.new(:voice_text => q.voice_text , :short_name => q.short_name, :average_priority => average_priority, :question_text => q.question_text)
      end
      # omg hard-coded question id i hate everything
      @voice_question_id = Question.find_by_short_name("neighborhood_comments")
      @user_voice_messages = FeedbackInput.where(:neighborhood_id => params[:id], :question_id => @voice_question_id).where.not(:voice_file_url => nil)
    elsif @subject.type == "Property"
      @questions_raw = Question.where(:short_name => ["property_outcome"])
      @questions     = Array.new
      @questions_raw.each do |q|
        response_hash = Hash.new
        ["Repair", "Remove", "Other"].each_with_index do |choice, index|
          @count_of_response    = FeedbackInput.where(:question_id => q.id, :property_id => params[:id], :numerical_response => (index+1)).count
          response_hash[choice] = @count_of_response
        end
        @questions << OpenStruct.new(:voice_text => q.voice_text , :short_name => q.short_name, :response_hash => response_hash, :question_text => q.question_text)
      end
      # omg hard-coded question id i hate everything
      @voice_question_id   = Question.find_by_short_name("property_comments").id
      @user_voice_messages = FeedbackInput.where(:property_id => params[:id], :question_id => @voice_question_id).where.not(:voice_file_url => nil)
    end
    # Check for any responses
    @feedback_responses_exist = false
    @questions.each do |question|
      question.response_hash.each_pair do |response_text, response_count|
        @feedback_responses_exist = true if response_count > 0
      end
    end
    # May need to make this conditional as well
    #@user_voice_messages = FeedbackInput.where(:neighborhood_id => params[:id]).where.not(:voice_file_url => nil)
  end

  # GET /subjects/new
  def new
    @subject = Subject.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects
  # POST /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: 'Subject was successfully created.' }
        format.json { render action: 'show', status: :created, location: @subject }
      else
        format.html { render action: 'new' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1
  # PATCH/PUT /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: 'Subject was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.json
  def destroy
    @subject.destroy
    respond_to do |format|
      format.html { redirect_to subjects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subject_params
      params.require(:subject).permit(:name, :neighborhood_id, :type)
    end
end
