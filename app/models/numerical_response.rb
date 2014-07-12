class NumericalResponse < Struct.new(:question, :location)
  extend Forwardable

  def_delegators :question, :short_name, :question_text

  def response_hash
    total = location.answers.count * 0.01
    %w(Agree Disagree).each_with_index.reduce({}) do |hash, (choice, index)|
      hash[choice] = location.answers
                             .where(question: question)
                             .where(numerical_response: (index+1))
                             .count / total
      hash
    end
  end

  def has_numeric_response?
    response_hash.values.any? { |v| v > 0 }
  end
end
