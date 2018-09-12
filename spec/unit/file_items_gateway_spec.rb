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

  it 'can delete the first two item' do
    item1_builder = Builder::Item.new
    item1_builder.from(id: '108', name: 'Jeremy', price: '28.00', quantity: '1')
    item1 = item1_builder.build

    item2_builder = Builder::Item.new
    item2_builder.from(id: '18', name: 'Amy', price: '8.00', quantity: '2')
    item2 = item2_builder.build

    item3_builder = Builder::Item.new
    item3_builder.from(id: '8', name: 'Jeremy', price: '18.00', quantity: '5')
    item3 = item3_builder.build

    items = [item1, item2, item3]

    file_items_gateway.save(items)

    expect(file_items_gateway.all.count).to eq(3)
    expect(file_items_gateway.all).not_to(be_nil)

    file_items_gateway.delete_item_at(0)
    file_items_gateway.delete_item_at(0)
    expect(file_items_gateway.all.count).to eq(1)

    file_items_gateway.all.tap do |items|
      expect(items[0].id).to eq('8')
      expect(items[0].name).to eq('Jeremy')
      expect(items[0].price).to eq('18.00')
      expect(items[0].quantity).to eq('5')
      expect(items[1]).to eq(nil)
      expect(items[2]).to eq(nil)
    end
  end
end
