require 'spec_helper'

describe OfferManager do
  let(:red_widget) { Product.new('R01', 32.95) }
  let(:green_widget) { Product.new('G01', 24.95) }
  let(:blue_widget) { Product.new('B01', 7.95) }

  describe '#apply_offers' do
    context 'with no offers' do
      let(:offer_manager) { OfferManager.new([]) }

      it 'returns items unchanged' do
        items = [red_widget, green_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result).to eq(items)
      end
    end

    context 'with RedWidgetHalfPriceOffer' do
      let(:offer) { RedWidgetHalfPriceOffer.new }
      let(:offer_manager) { OfferManager.new([offer]) }

      it 'does not apply discount with only one red widget' do
        items = [red_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result.first.price).to eq(32.95)
      end

      it 'applies half price to second red widget' do
        items = [red_widget, red_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result[0].price).to eq(32.95)
        expect(result[1].price).to eq(16.48)
      end

      it 'applies discount to pairs only' do
        items = [red_widget, red_widget, red_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result[0].price).to eq(32.95)
        expect(result[1].price).to eq(16.48)
        expect(result[2].price).to eq(32.95)
      end

      it 'applies discount to multiple pairs' do
        items = [red_widget, red_widget, red_widget, red_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result[0].price).to eq(32.95)
        expect(result[1].price).to eq(16.48)
        expect(result[2].price).to eq(32.95)
        expect(result[3].price).to eq(16.48)
      end

      it 'does not affect non-red widgets' do
        items = [red_widget, green_widget, red_widget, blue_widget]
        result = offer_manager.apply_offers(items)
        
        expect(result[1]).to eq(green_widget)
        expect(result[3]).to eq(blue_widget)
      end
    end
  end
end

describe RedWidgetHalfPriceOffer do
  let(:offer) { RedWidgetHalfPriceOffer.new }
  let(:red_widget) { Product.new('R01', 32.95) }
  let(:green_widget) { Product.new('G01', 24.95) }

  describe '#apply' do
    it 'returns items unchanged when less than 2 red widgets' do
      items = [red_widget, green_widget]
      result = offer.apply(items)
      
      expect(result).to eq(items)
    end

    it 'creates new discounted product instances' do
      items = [red_widget, red_widget]
      result = offer.apply(items)
      
      expect(items[0].price).to eq(32.95)
      expect(items[1].price).to eq(32.95)
      
      expect(result[0].price).to eq(32.95)
      expect(result[1].price).to eq(16.48)
    end
  end
end