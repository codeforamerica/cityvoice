class NumericalResponse < Struct.new(:question, :subject)
  extend Forwardable

  def_delegators :question, :short_name, :question_text

  def response_hash
    %w(Repair Remove).each_with_index.reduce({}) do |hash, (choice, index)|
      hash[choice] = subject.feedback_inputs
                            .where(question: question)
                            .where(numerical_response: (index+1))
                            .count
      hash
    end
  end

  def has_numeric_response?
    response_hash.values.any? { |v| v > 0 }
  end
end
