# frozen_string_literal: true

describe FileItemsGateway do
  let(:file_items_gateway) { described_class.new }

  before do
    file_items_gateway.delete_all
  end

  it 'can get no items' do
    expect(file_items_gateway.all).to eq([])
  end

  it 'can get a row of item details' do
    item_builder = Builder::Item.new
    item_builder.from(id: '108', name: 'Jeremy', price: '28.00', quantity: '1')
 
    item = item_builder.build

    file_items_gateway.save([item])

    file_items_gateway.all.first.tap do |items|
      expect(items.id).to eq('108')
      expect(items.name).to eq('Jeremy')
      expect(items.price).to eq('28.00')
      expect(items.quantity).to eq('1')
    end
  end

  it 'can delete the entire file' do
    
  end 
end
