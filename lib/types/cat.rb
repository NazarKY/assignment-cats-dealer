# frozen_string_literal: true

module Types
  Cat = Struct.new(:name, :price, :location, :image) do
    def initialize(name, price, location, image)
      validate_presence!(name, 'Name')
      validate_presence!(price, 'Price')
      validate_presence!(location, 'Location')
      validate_presence!(image, 'Image')

      super(name, price, location, image)
    end

    def to_h
      {
        name:,
        price:,
        location:,
        image:,
      }
    end

    private

    def validate_presence!(attribute, attribute_name)
      raise ::Errors::InvalidCatError, "#{attribute_name} is missing" if attribute.blank?
    end
  end
end
