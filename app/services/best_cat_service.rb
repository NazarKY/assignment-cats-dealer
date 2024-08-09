# frozen_string_literal: true

class BestCatService
  def initialize(fetchers)
    @fetchers = fetchers
  end

  def fetch_all_cats
    fetchers.each_with_object([]) do |fetcher, cats|
      cats.concat(fetcher.fetch)
    end
  end

  def find_best_deal
    fetch_all_cats.min_by(&:price)
  end

  private

  attr_reader :fetchers
end
