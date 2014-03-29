require 'csv'

class LocationImporter < Struct.new(:content)
  REQUIRED_HEADERS = %w(name lat long).map(&:to_sym)

  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def has_valid_headers?
    missing_headers.empty?
  end

  def valid?
    has_valid_headers? && locations.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(locations)
  end

  def import
    locations.each(&:save!) if valid?
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

  def locations
    csv_entries.map(&:to_hash).map { |p| Location.new(p) }
  end

  def headers
    @headers ||= csv_entries.first.headers
  end
end
