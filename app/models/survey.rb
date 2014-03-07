module Survey
  def self.questions_for(survey_type)
    if survey_type == "neighborhood"
      ["public_safety", "property_values", "neighborhood_comments"]
    elsif survey_type == "property"
      ["property_outcome", "property_comments"]
    elsif survey_type == "iwtw"
      ["i_wish_comment"]
    end
  end
end
