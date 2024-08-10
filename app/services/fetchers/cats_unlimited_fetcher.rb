# frozen_string_literal: true

require 'json'

module Fetchers
  class CatsUnlimitedFetcher < BaseFetcher
    URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'

    private

    def parse(response)
      JSON.parse(response).map do |cat|
        Cat.new(
          cat['name'],
          cat['price'].to_f,
          cat['location'],
          cat['image']
        )
      end
    end
  end
end
