# frozen_string_literal: true

require 'net/http'
require 'singleton'

module Fetchers
  class BaseFetcher
    include Singleton

    MAX_RETRIES = 3
    RETRY_DELAY = 2 # seconds

    def fetch
      fetch_data
    end

    private

    attr_reader :url

    def fetch_data
      uri = URI(url)
      retries = 0

      begin
        response = Net::HTTP.get(uri)
        parse(response)
      rescue StandardError => e
        retries += 1
        Rails.logger.error("Error fetching data from #{url}: #{e.message}, retrying (#{retries}/#{MAX_RETRIES})")

        sleep RETRY_DELAY * retries if retries < MAX_RETRIES
        retry if retries < MAX_RETRIES

        Rails.logger.error("Failed to fetch data from #{url} after #{MAX_RETRIES} attempts")

        []
      end
    end

    def parse(_response)
      raise NotImplementedError, "Subclasses must implement the `parse` method"
    end
  end
end
