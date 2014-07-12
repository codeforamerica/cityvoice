require 'csv'

class AnswerCounts < Struct.new(:total_counts, :agree_counts, :disagree_counts)
  def total_hash
    total_counts.reduce({}) do |hash, (property, calls)|
      hash[property] = {total: calls}
      hash
    end
  end

  def agree_hash
    agree_counts.reduce({}) do |hash, (property, agrees)|
      hash[property] = {agree: agrees}
      hash
    end
  end

  def disagree_hash
    disagree_counts.reduce({}) do |hash, (property, disagrees)|
      hash[property] = {disagree: disagrees}
      hash
    end
  end

  def to_hash
    total_hash.deep_merge(agree_hash).deep_merge(disagree_hash)
  end

  def to_array
    array = Array.new
    to_hash.each { |elem| array << elem }
    array.sort_by { |elem| elem[1][:total].to_i }.reverse
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w[Address Total Agree Disagree]
      to_array.each do |location, count_hash|
        csv << [
          location.name,
          count_hash[:total] || 0,
          count_hash[:agree] || 0,
          count_hash[:disagree] || 0,
        ]
      end
    end
  end
end
