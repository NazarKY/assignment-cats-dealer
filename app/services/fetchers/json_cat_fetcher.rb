# frozen_string_literal: true

require 'json'

module Fetchers
  class JsonCatFetcher < BaseFetcher
    def initialize
      @url = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'
    end

    private

    def parse(response)
      JSON.parse(response).map do |cat|
        {
          'name' => cat['name'],
          'price' => cat['price'].to_f,
          'location' => cat['location'],
          'image' => cat['image']
        }
      end
    end
  end
end
