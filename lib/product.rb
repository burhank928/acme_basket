# frozen_string_literal: true

# Represents a product with a code and price
class Product
  attr_reader :code, :price

  def initialize(code, price)
    @code = code
    @price = price
  end

  def ==(other)
    other.is_a?(Product) && code == other.code && price == other.price
  end

  def to_s
    "#{code}: $#{format('%.2f', price)}"
  end
end