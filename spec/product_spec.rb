require 'spec_helper'

describe Product do
  let(:product) { Product.new('R01', 32.95) }

  describe '#initialize' do
    it 'creates a product with code and price' do
      expect(product.code).to eq('R01')
      expect(product.price).to eq(32.95)
    end
  end

  describe '#==' do
    it 'returns true for products with same code and price' do
      other_product = Product.new('R01', 32.95)
      expect(product).to eq(other_product)
    end

    it 'returns false for products with different code or price' do
      different_product = Product.new('G01', 24.95)
      expect(product).not_to eq(different_product)
    end
  end

  describe '#to_s' do
    it 'returns formatted string representation' do
      expect(product.to_s).to eq('R01: $32.95')
    end
  end
end