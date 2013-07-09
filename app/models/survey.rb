class Survey 
  attr_accessor :questions

  def initialize(survey_type)
    if survey_type == "neighborhood"
      @questions = ["public_safety", "property_values", "neighborhood_comments"]
    end
  end

end

