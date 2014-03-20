require 'csv'

class SubjectImporter < Struct.new(:content)
  REQUIRED_HEADERS = %w(name lat long).map(&:to_sym)

  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def has_valid_headers?
    missing_headers.empty?
  end

  def valid?
    has_valid_headers? && subjects.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(subjects)
  end

  def import
    subjects.each(&:save!) if valid?
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

  def subjects
    csv_entries.map(&:to_hash).map { |p| Subject.new(p) }
  end

  def headers
    @headers ||= csv_entries.first.headers
  end
end
