# frozen_string_literal: true

module Validators
  module CatValidator
    def validate_cat_attributes!(title:, cost:, location:, image:)
      raise ::Errors::InvalidCatError, 'Title is missing' if title.blank?
      raise ::Errors::InvalidCatError, 'Cost is missing or invalid' if cost.blank?
      raise ::Errors::InvalidCatError, 'Location is missing' if location.blank?
      raise ::Errors::InvalidCatError, 'Image is missing' if image.blank?
    end
  end
end
