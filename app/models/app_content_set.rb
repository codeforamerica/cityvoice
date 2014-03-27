require 'csv'

class AppContentSet < Struct.new(:content)
  REQUIRED_HEADERS = %w(
    app_phone_number
    call_in_code_digits
    call_instruction
    call_text
    feedback_form_url
    header_color
    issue
    learn_text
    listen_text
    message_from
    message_url
    short_title
  ).map(&:to_sym)

  def self.load!(path)
    content = File.read(path)
    content_set = new(content)
    raise "Invalid app content set" unless content_set.valid?
    OpenStruct.new(content_set.to_a.first)
  end

  def valid?
    !to_a.empty? && missing_headers.empty?
  end

  def to_a
    @content_sets ||= csv_entries.map(&:to_hash)
  end

  protected

  def missing_headers
    REQUIRED_HEADERS - headers
  end

  def csv_entries
    @csv_entries ||= CSV.new(content, headers: true, header_converters: :symbol).entries
  end

  def headers
    @headers ||= csv_entries.first.headers
  end
end
