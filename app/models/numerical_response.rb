class NumericalResponse < Struct.new(:question, :location)
  extend Forwardable

  def_delegators :question, :short_name, :question_text

  def response_hash
    %w(Agree Disagree).each_with_index.reduce({}) do |hash, (choice, index)|
      hash[choice] = location.answers
                             .where(question: question)
                             .where(numerical_response: (index+1))
                             .count
      hash
    end
  end

  def total_response_count
    response_hash.values.reduce(:+)
  end

  def has_numeric_response?
    response_hash.values.any? { |v| v > 0 }
  end
end
