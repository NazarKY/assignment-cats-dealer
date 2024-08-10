# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Fetchers::HappyCatsFetcher do
  let(:url) { 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml' }
  let(:fetcher) { described_class.new }
  let(:http_service) { instance_double(HttpService) }
  let(:response_body) do
    <<-XML
      <cats>
        <cat>
          <title>Bengal</title>
          <cost>600</cost>
          <location>Odesa</location>
          <img>bengal.jpg</img>
        </cat>
        <cat>
          <title>Siamese</title>
          <cost>400</cost>
          <location>Kyiv</location>
          <img>siamese.jpg</img>
        </cat>
      </cats>
    XML
  end

  before do
    allow(fetcher).to receive(:http_service).and_return(http_service)
    allow(http_service).to receive(:get).with(url).and_return(response_body)
  end

  describe '#fetch' do
    it 'fetches and parses the XML response, returning an array of Cat objects' do
      cats = fetcher.fetch

      expect(cats.size).to eq(2)
      expect(cats.first).to be_an_instance_of(Cat)
      expect(cats.first).to have_attributes(
                              name: 'Bengal',
                              price: 600.0,
                              location: 'Odesa',
                              image: 'bengal.jpg'
                            )
      expect(cats.last).to be_an_instance_of(Cat)
      expect(cats.last).to have_attributes(
                             name: 'Siamese',
                             price: 400.0,
                             location: 'Kyiv',
                             image: 'siamese.jpg'
                           )
    end

    it 'returns an empty array if the response contains no cats' do
      empty_response = '<cats></cats>'
      allow(http_service).to receive(:get).with(url).and_return(empty_response)

      cats = fetcher.fetch

      expect(cats).to eq([])
    end
  end
end
