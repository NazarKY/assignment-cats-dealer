# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fetchers::CatsUnlimitedFetcher do
  let(:fetcher) { described_class.new }
  let(:http_service) { instance_double(HttpService) }
  let(:response_body) do
    [
      { 'name' => 'Bengal', 'price' => 500, 'location' => 'Odesa', 'image' => 'bengal.jpg' },
      { 'name' => 'Siamese', 'price' => 300, 'location' => 'Kyiv', 'image' => 'siamese.jpg' }
    ].to_json
  end

  before do
    allow(fetcher).to receive(:http_service).and_return(http_service)
    allow(http_service).to receive(:get).with(described_class::URL).and_return(response_body)
  end

  describe '#fetch' do
    it 'fetches and parses the JSON response, returning an array of Cat objects' do
      cats = fetcher.fetch

      expect(cats.size).to eq(2)
      expect(cats.first).to be_an_instance_of(Cat)
      expect(cats.first).to have_attributes(
                              name: 'Bengal',
                              price: 500.0,
                              location: 'Odesa',
                              image: 'bengal.jpg'
                            )
      expect(cats.last).to be_an_instance_of(Cat)
      expect(cats.last).to have_attributes(
                             name: 'Siamese',
                             price: 300.0,
                             location: 'Kyiv',
                             image: 'siamese.jpg'
                           )
    end

    it 'returns an empty array if the response is empty' do
      allow(http_service).to receive(:get).with(described_class::URL).and_return('[]')

      cats = fetcher.fetch

      expect(cats).to eq([])
    end
  end
end
