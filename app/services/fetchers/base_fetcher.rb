# frozen_string_literal: true

module Fetchers
  class BaseFetcher
    def initialize
      @http_service = ::HttpService.new
    end

    def fetch
      response = http_service.get(url)

      response ? parse(response) : []
    end

    private

    attr_reader :url, :http_service

    def parse(_response)
      raise NotImplementedError, "Subclasses must implement the `parse` method"
    end
  end
end
