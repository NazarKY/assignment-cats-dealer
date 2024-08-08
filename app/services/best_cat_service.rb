# frozen_string_literal: true

class BestCatService
  def initialize(fetchers)
    @fetchers = fetchers
  end

  def fetch_all_cats
    fetchers.each_with_object([]) do |fetcher, cats|
      cats.concat(fetcher.fetch_cats)
    end
  end

  def find_best_deal
    fetch_all_cats.min_by { |cat| cat['price'] }
  end

  attr_reader :fetchers
end
