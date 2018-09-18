describe CalculateVAT do
  let(:items_gateway) { spy(all: items) }
  let(:use_case) { described_class.new(items_gateway: items_gateway) }

  class ItemStub
    def initialize(total)
      @total = total
    end

    attr_reader :total
  end

  context 'given no items' do
    let(:items) { [] }
    it 'returns 0' do
      expect(use_case.execute).to eq('0.00')
    end
  end

  context 'given one item' do
    let(:items) { [ItemStub.new(BigDecimal('5'))] }
    it 'returns one item VAT total' do
      expect(use_case.execute).to eq('1.00')
    end
  end 

  context 'given multiple items' do
    let(:items) do
      [ItemStub.new(BigDecimal('5.25')),
       ItemStub.new(BigDecimal('10.50')),
       ItemStub.new(BigDecimal('2.50'))]
    end
    it 'returns multiple items vat total' do
      expect(use_case.execute).to eq('3.65')
    end
  end
end
