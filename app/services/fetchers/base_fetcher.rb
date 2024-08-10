# frozen_string_literal: true

module Fetchers
  class BaseFetcher
    def initialize(http_service: ::HttpService.new)
      @http_service = http_service
    end

    def fetch
      response = http_service.get(self.class::URL)

      response ? parse(response) : []
    end

    private

    attr_reader :url, :http_service

    def parse(_response)
      raise NotImplementedError, "Subclasses must implement the `parse` method"
    end
  end
end
