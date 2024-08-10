# frozen_string_literal: true

require 'json'

module Fetchers
  class CatsUnlimitedFetcher < BaseFetcher
    include ::Validators::CatValidator

    URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'

    private

    def parse(response)
      JSON.parse(response).map do |cat|
        begin
          title = cat['name']
          cost = cat['price'].to_f
          location = cat['location']
          image = cat['image']

          validate_cat_attributes!(title:, cost:, location:, image:)

          Cat.new(title, cost, location, image)
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
