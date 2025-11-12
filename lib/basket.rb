# frozen_string_literal: true

require_relative 'product'
require_relative 'delivery_calculator'
require_relative 'offer_manager'

# Main basket class that manages products, offers, and delivery
class Basket
  def initialize(product_catalogue, delivery_calculator = nil, offer_manager = nil)
    @product_catalogue = product_catalogue
    @delivery_calculator = delivery_calculator || DeliveryCalculator.new
    @offer_manager = offer_manager || OfferManager.new([RedWidgetHalfPriceOffer.new])
    @items = []
  end

  def add(product_code)
    product = @product_catalogue[product_code]
    raise ArgumentError, "Product #{product_code} not found" unless product

    @items << product
  end

  def total
    discounted_items = @offer_manager.apply_offers(@items)
    
    subtotal = discounted_items.sum(&:price)
    
    delivery_cost = @delivery_calculator.calculate(subtotal)
    
    (subtotal + delivery_cost).round(2)
  end

  def items_summary
    @items.group_by(&:code).transform_values(&:count)
  end

  def clear
    @items.clear
  end
end