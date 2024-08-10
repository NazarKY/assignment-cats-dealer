# frozen_string_literal: true

require 'nokogiri'

module Fetchers
  class HappyCatsFetcher < BaseFetcher
    URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml'

    private

    def parse(response)
      doc = Nokogiri::XML(response)

      doc.xpath('//cat').each_with_object([]) do |cat, cats|
        cats << Cat.new(
          cat.at_xpath('title').text,
          cat.at_xpath('cost').text.to_f,
          cat.at_xpath('location').text,
          cat.at_xpath('img').text
        )
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Failed to parse XML response: #{e.message}")
      []
    end
  end
end
