require 'nokogiri'

RSpec::Matchers.define :redirect_twilio_to do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    node = doc.xpath('Response/Redirect')
    !node.empty? && node.text == expected
  end
end

RSpec::Matchers.define :gather_and_redirect_twilio_to do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    node = doc.xpath('Response/Gather')
    !node.empty? && node.any? { |n| n.attributes['action'].try(:value) == expected }
  end
end

RSpec::Matchers.define :record_and_redirect_twilio_to do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    node = doc.xpath('Response/Record')
    !node.empty? && node.any? { |n| n.attributes['action'].try(:value) == expected }
  end
end

RSpec::Matchers.define :play_twilio_url do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    node = doc.xpath('Response//Play')
    if expected.is_a?(Regexp)
      !node.empty? && expected =~ node.map(&:text).join(' ')
    else
      !node.empty? && node.map(&:text).include?(expected)
    end
  end
end

RSpec::Matchers.define :hangup_twilio do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    nodes = doc.xpath('Response/Hangup')
    !nodes.empty?
  end
end
