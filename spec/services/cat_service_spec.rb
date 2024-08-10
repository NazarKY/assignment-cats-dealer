# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatService do
  let(:fetcher1) { instance_double("Fetchers::CatsUnlimitedFetcher") }
  let(:fetcher2) { instance_double("Fetchers::HappyCatsFetcher") }
  let(:cat1) { Cat.new('Bengal', 500, 'Odessa', 'bengal.jpg') }
  let(:cat2) { Cat.new('Siamese', 300, 'Kyiv', 'siamese.jpg') }
  let(:cat3) { Cat.new('Persian', 200, 'Lviv', 'persian.jpg') }

  let(:service) { described_class.new([fetcher1, fetcher2]) }

  describe '#fetch_all_cats' do
    it 'returns all cats from all fetchers' do
      allow(fetcher1).to receive(:fetch).and_return([cat1, cat2])
      allow(fetcher2).to receive(:fetch).and_return([cat3])

      result = service.fetch_all_cats

      expect(result).to contain_exactly(cat1, cat2, cat3)
    end

    it 'returns an empty array if all fetchers return empty arrays' do
      allow(fetcher1).to receive(:fetch).and_return([])
      allow(fetcher2).to receive(:fetch).and_return([])

      result = service.fetch_all_cats

      expect(result).to eq([])
    end
  end

  describe '#find_best_deal' do
    it 'returns the cat with the lowest price' do
      allow(service).to receive(:fetch_all_cats).and_return([cat1, cat2, cat3])

      best_deal = service.find_best_deal

      expect(best_deal).to eq(cat3) # Persian cat is the cheapest
    end

    it 'returns nil if there are no cats' do
      allow(service).to receive(:fetch_all_cats).and_return([])

      best_deal = service.find_best_deal

      expect(best_deal).to be_nil
    end
  end
end
