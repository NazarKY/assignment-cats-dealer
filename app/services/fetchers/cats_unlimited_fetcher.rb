# frozen_string_literal: true

require 'json'

module Fetchers
  class CatsUnlimitedFetcher < BaseFetcher
    URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'

    private

    def parse(response)
      JSON.parse(response).each_with_object([]) do |cat, cats|
        begin
          title = cat['name']
          cost = cat['price'].to_f
          location = cat['location']
          image = cat['image']

          cats << ::Types::Cat.new(title, cost, location, image)
        rescue ::Errors::InvalidCatError => e
          Rails.logger.error("Invalid cat data: #{e.message}. Skipping this cat.")
        end
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Failed to parse JSON response: #{e.message}")
      []
    end
  end
end
