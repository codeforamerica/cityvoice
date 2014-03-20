class ImporterErrors < Struct.new(:record, :line_number)
  def self.messages_for(records = [])
    records.each_with_index.map do |record, index|
      new(record, index + 2).message
    end.reject { |m| m.nil? }
  end

  def message
    "Line #{line_number}: #{error_messages}" unless record.valid?
  end

  protected

  def error_messages
    record.errors.full_messages.join(', ')
  end
end
