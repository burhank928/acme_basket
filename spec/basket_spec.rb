require 'spec_helper'

describe Basket do
  let(:product_catalogue) do
    {
      'R01' => Product.new('R01', 32.95),
      'G01' => Product.new('G01', 24.95),
      'B01' => Product.new('B01', 7.95)
    }
  end

  let(:basket) { Basket.new(product_catalogue) }

  describe '#initialize' do
    it 'creates a basket with product catalogue' do
      expect(basket).to be_a(Basket)
    end

    it 'accepts custom delivery calculator and offer manager' do
      custom_delivery = DeliveryCalculator.new
      custom_offers = OfferManager.new([])
      
      custom_basket = Basket.new(product_catalogue, custom_delivery, custom_offers)
      expect(custom_basket).to be_a(Basket)
    end
  end

  describe '#add' do
    it 'adds products by product code' do
      basket.add('R01')
      basket.add('G01')
      
      expect(basket.items_summary).to eq({ 'R01' => 1, 'G01' => 1 })
    end

    it 'raises error for unknown product code' do
      expect { basket.add('UNKNOWN') }.to raise_error(ArgumentError, 'Product UNKNOWN not found')
    end
  end

  describe '#total' do
    context 'with the provided test cases' do
      it 'calculates correct total for B01, G01 -> $37.85' do
        basket.add('B01')
        basket.add('G01')
        
        expect(basket.total).to eq(37.85)
      end

      it 'calculates correct total for R01, R01 -> $54.38' do
        basket.add('R01')
        basket.add('R01')
        
        expect(basket.total).to eq(54.38)
      end

      it 'calculates correct total for R01, G01 -> $60.85' do
        basket.add('R01')
        basket.add('G01')
        
        expect(basket.total).to eq(60.85)
      end

      it 'calculates correct total for B01, B01, R01, R01, R01 -> $98.28' do
        basket.add('B01')
        basket.add('B01')
        basket.add('R01')
        basket.add('R01')
        basket.add('R01')
        
        expect(basket.total).to eq(98.28)
      end
    end

    context 'delivery costs' do
      it 'charges $4.95 delivery for orders under $50' do
        basket.add('B01')
        expect(basket.total).to eq(12.90)
      end

      it 'charges $2.95 delivery for orders $50-$89.99' do
        basket.add('R01')
        basket.add('G01')
        expect(basket.total).to eq(60.85)
      end

      it 'charges no delivery for orders $90+' do
        basket.add('R01')
        basket.add('R01')
        basket.add('G01')
        basket.add('B01')
        basket.add('B01')
        
        expect(basket.total).to eq(90.28)
      end
    end
  end

  describe '#clear' do
    it 'clears all items from basket' do
      basket.add('R01')
      basket.add('G01')
      
      basket.clear
      expect(basket.items_summary).to eq({})
      expect(basket.total).to eq(4.95)
    end
  end
end