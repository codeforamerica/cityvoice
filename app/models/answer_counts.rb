require 'csv'

class AnswerChoiceCounter < Struct.new(:question_short_name, :choice_name)
  def count(location)
    location.answers.where(choice_id: choice.id).count
  end

  protected

  def question
    Question.find_by!(short_name: question_short_name)
  end

  def choice
    question.choices.find_by!(name: choice_name)
  end
end

class AnswerCounts
  def total_hash
    Location.all.reduce({}) do |hash, location|
      hash[location] = {total: location.calls.count}
      hash
    end
  end

  def repair_hash
    counter = AnswerChoiceCounter.new('property_outcome', 'Repair')
    Location.all.reduce({}) do |hash, location|
      hash[location] = {repair: counter.count(location)}
      hash
    end
  end

  def remove_hash
    counter = AnswerChoiceCounter.new('property_outcome', 'Remove')
    Location.all.reduce({}) do |hash, location|
      hash[location] = {remove: counter.count(location)}
      hash
    end
  end

  def to_hash
    total_hash.deep_merge(repair_hash).deep_merge(remove_hash)
  end

  def to_array
    array = Array.new
    to_hash.each { |elem| array << elem }
    array.sort_by { |elem| elem[1][:total].to_i }.reverse
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[Address Total Repair Remove]
      to_array.each do |location, count_hash|
        csv << [
          location.name,
          count_hash[:total] || 0,
          count_hash[:repair] || 0,
          count_hash[:remove] || 0,
        ]
      end
    end
  end
end
