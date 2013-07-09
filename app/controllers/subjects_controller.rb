class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]

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
    @questions_raw = Question.where(:short_name => ["public_safety", "property_values"])
    @questions = Array.new
    @questions_raw.each do |q|
      @questions << OpenStruct.new(:voice_text => q.voice_text , :short_name => q.short_name, :average_priority => Kernel.rand*5)
    end
    @user_voice_messages = Array.new
    3.times do
      @user_voice_messages << OpenStruct.new(:voice_url => "http://www.myvoiceurlssdds.com", :public_safety => rand(1..5), :property_values => rand(1..5), :phone_number => "1234567890", :date => "06/09/13")
    end
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
