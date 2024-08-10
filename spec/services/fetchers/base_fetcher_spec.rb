# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fetchers::BaseFetcher do
  let(:url) { 'https://example.com' }
  let(:http_service) { instance_double(HttpService) }

  let(:fetcher_class) do
    Class.new(described_class) do
      def initialize(http_service)
        @url = 'https://example.com'
        @http_service = http_service
      end

      private

      def parse(response)
        response
      end
    end
  end
  let(:fetcher) { fetcher_class.new(http_service) }

  let(:incomplete_fetcher_class) do
    Class.new(described_class) do
      def initialize(http_service)
        @url = 'https://example.com'
        @http_service = http_service
      end
    end
  end
  let(:incomplete_fetcher) { incomplete_fetcher_class.new(http_service) }

  describe '#fetch' do
    context 'when response is not nil' do
      before do
        allow(http_service).to receive(:get).and_return('raw_response')
      end

      context 'when the fetcher is called' do
        it 'calls the HTTP service with the correct URL' do
          fetcher.fetch
          expect(http_service).to have_received(:get).with(url)
        end

        it 'calls the parse method with the HTTP response' do
          result = fetcher.fetch
          expect(result).to eq('raw_response')
        end
      end

      context 'when parse is not implemented in the subclass' do
        it 'raises a NotImplementedError' do
          expect { incomplete_fetcher.fetch }.to raise_error(NotImplementedError, /Subclasses must implement the `parse` method/)
        end
      end
    end

    context 'when response is nil' do
      context 'when the HTTP service returns nil' do
        before do
          allow(http_service).to receive(:get).and_return(nil)
        end

        it 'returns an empty array' do
          expect(fetcher.fetch).to eq([])
        end
      end
    end
  end
end
