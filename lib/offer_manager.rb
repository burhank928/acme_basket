# frozen_string_literal: true

# Manages special offers using strategy pattern
class OfferManager
  def initialize(offers = [])
    @offers = offers
  end

  def apply_offers(items)
    discounted_items = items.dup
    
    @offers.each do |offer|
      discounted_items = offer.apply(discounted_items)
    end
    
    discounted_items
  end
end

# Base class for offers
class Offer
  def apply(items)
    raise NotImplementedError, 'Subclasses must implement apply method'
  end
end

# "Buy one red widget, get the second half price" offer
class RedWidgetHalfPriceOffer < Offer
  def apply(items)
    return items if items.count { |item| item.code == 'R01' } < 2

    discounted_items = items.dup
    red_widget_count = 0
    
    discounted_items.each_with_index do |item, index|
      if item.code == 'R01'
        red_widget_count += 1
        if red_widget_count.even?
          discounted_price = (item.price * 0.5).round(2)
          discounted_items[index] = Product.new(item.code, discounted_price)
        end
      end
    end
    
    discounted_items
  end
end