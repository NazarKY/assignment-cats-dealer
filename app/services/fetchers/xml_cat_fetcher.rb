# frozen_string_literal: true

require 'nokogiri'

module Fetchers
  class XmlCatFetcher < BaseFetcher
    def initialize
      super
      @url = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml'
    end

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
    end
  end
end
