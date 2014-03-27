require 'csv'

class QuestionImporter < Struct.new(:content)
  REQUIRED_HEADERS = %w(short_name feedback_type question_text voice_file_url).map(&:to_sym)

  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def has_valid_headers?
    missing_headers.empty?
  end

  def valid?
    has_valid_headers? && questions.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(questions)
  end

  def import
    questions.each(&:save!) if valid?
  end

  protected

  def header_errors
    missing_headers.map { |header| "#{header.to_s.humanize} column is missing" }
  end

  def missing_headers
    REQUIRED_HEADERS - headers
  end

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end

  def questions
    csv_entries.map(&:to_hash).map { |p| QuestionPresenter.new(p).to_question }
  end

  def headers
    @headers ||= csv_entries.first.headers
  end
end
