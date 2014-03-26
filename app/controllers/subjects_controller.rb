class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find_by_param(params[:id])
    @numerical_questions_raw = Question.where(:feedback_type => "numerical_response")
    @numerical_responses = Array.new
    @numerical_questions_raw.each do |q|
      response_hash = Hash.new
      ["Repair", "Remove"].each_with_index do |choice, index|
        @count_of_response = @subject.feedback_inputs.where(:question_id => q.id, :numerical_response => (index+1)).count
        response_hash[choice] = @count_of_response
      end
      @numerical_responses << OpenStruct.new(:short_name => q.short_name, :response_hash => response_hash, :question_text => q.question_text)
    end

    # Brittle: will want to deal with multiple possible voice questions in the future
    @user_voice_messages = @subject.feedback_inputs.where.not(:voice_file_url => nil)
    # Check for any responses
    @numerical_responses.each do |question|
      question.response_hash.each_pair do |response_text, response_count|
        @numerical_responses_exist = true if response_count > 0
      end
    end
  end
end
