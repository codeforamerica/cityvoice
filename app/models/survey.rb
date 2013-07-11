module Survey 
  def self.questions_for(survey_type)
    if survey_type == "neighborhood"
      ["public_safety", "property_values", "neighborhood_comments"]
    elsif survey_type == "property"
      # Old, combined
      #["property_outcome", "public_safety", "property_values", "neighborhood_comments", "property_comments"]
      # New -- property questions only
      ["property_outcome", "property_comments"]
    end
  end

=begin
  attr_accessor :questions
  def initialize(survey_type)
    if survey_type == "neighborhood"
      @questions = ["public_safety", "property_values", "neighborhood_comments"]
    end
  end
=end

end
