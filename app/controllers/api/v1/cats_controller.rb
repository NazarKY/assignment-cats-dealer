# frozen_string_literal: true

module Api
  module V1
    class CatsController < ApplicationController
      def best_deal
        fetchers = [
          Fetchers::HappyCatsFetcher.new,
          Fetchers::CatsUnlimitedFetcher.new,
        ]

        service = BestCatService.new(fetchers)
        best_deal = service.find_best_deal

        if best_deal
          render json: best_deal.to_h, status: :ok
        else
          render json: { error: 'No cats available' }, status: :not_found
        end
      end
    end
  end
end
