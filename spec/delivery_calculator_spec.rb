require 'spec_helper'

describe DeliveryCalculator do
  let(:calculator) { DeliveryCalculator.new }

  describe '#calculate' do
    it 'returns $4.95 for orders under $50' do
      expect(calculator.calculate(0.0)).to eq(4.95)
      expect(calculator.calculate(25.0)).to eq(4.95)
      expect(calculator.calculate(49.99)).to eq(4.95)
    end

    it 'returns $2.95 for orders $50-$89.99' do
      expect(calculator.calculate(50.0)).to eq(2.95)
      expect(calculator.calculate(75.0)).to eq(2.95)
      expect(calculator.calculate(89.99)).to eq(2.95)
    end

    it 'returns $0 for orders $90+' do
      expect(calculator.calculate(90.0)).to eq(0.0)
      expect(calculator.calculate(150.0)).to eq(0.0)
    end
  end

  describe 'custom rules' do
    let(:custom_rules) do
      [
        { threshold: 0.0, cost: 10.0 },
        { threshold: 100.0, cost: 0.0 }
      ]
    end
    let(:custom_calculator) { DeliveryCalculator.new(custom_rules) }

    it 'uses custom delivery rules' do
      expect(custom_calculator.calculate(50.0)).to eq(10.0)
      expect(custom_calculator.calculate(100.0)).to eq(0.0)
    end
  end
end