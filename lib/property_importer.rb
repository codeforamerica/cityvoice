require 'csv'

class PropertyImporter < Struct.new(:content)
  REQUIRED_HEADERS = %w(name property_code lat long).map(&:to_sym)

  def self.import_file(path)
    content = File.read(path)
    new(content).tap(&:import)
  end

  def has_valid_headers?
    missing_headers.empty?
  end

  def valid?
    has_valid_headers? && properties.all?(&:valid?)
  end

  def errors
    header_errors + ImporterErrors.messages_for(properties)
  end

  def import
    properties.each(&:save!) if valid?
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

  def properties
    csv_entries.map(&:to_hash).map { |p| Property.new(p) }
  end

  def headers
    @headers ||= csv_entries.first.headers
  end
end
