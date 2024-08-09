# frozen_string_literal: true

Cat = Struct.new(:name, :price, :location, :image) do
  def to_h
    {
      name:,
      price:,
      location:,
      image:,
    }
  end
end
