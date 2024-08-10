# frozen_string_literal: true

require 'nokogiri'

module Fetchers
  class HappyCatsFetcher < BaseFetcher
    include ::Validators::CatValidator

    URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml'

    private

    def parse(response)
      doc = Nokogiri::XML(response)

      doc.xpath('//cat').each_with_object([]) do |cat, cats|
        begin
          title = cat.at_xpath('title')&.text
          cost = cat.at_xpath('cost')&.text.to_f
          location = cat.at_xpath('location')&.text
          image = cat.at_xpath('img')&.text

          validate_cat_attributes!(title:, cost:, location:, image:)

          cats << Cat.new(title, cost, location, image)
        rescue ::Errors::InvalidCatError => e
          Rails.logger.error("Invalid cat data: #{e.message}. Skipping this cat.")
        end
      end
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error("Failed to parse XML response: #{e.message}")
      []
    end
  end
end
