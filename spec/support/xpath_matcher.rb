RSpec::Matchers.define :match_xpath do |expected|
  match do |actual|
    doc = Nokogiri::XML::Document.parse(actual)
    nodes = doc.xpath(expected)
    !nodes.empty?
  end
end
