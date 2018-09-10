# frozen_string_literal: true

describe SaveItemsDetails do
  let(:items_gateway) { spy(all: []) }
  let(:dummy_item) { Class.new }
  let(:use_case) { described_class.new(items_gateway: items_gateway) }

  it 'uses the items gateway to save the order details' do
    item = { id: '456', name: 'Bots', price: '10.00', quantity: '2' }
    use_case.execute(item_details: item)
    expect(items_gateway).to have_received(:save) do |item|
      expect(item[0].id).to eq('456')
      expect(item[0].name).to eq('Bots')
      expect(item[0].price).to eq('10.00')
      expect(item[0].quantity).to eq('2')
    end
  end

  it 'uses the items gateway to save multiple rows' do
    gateway = spy(all: [dummy_item])
    item_use_case = described_class.new(items_gateway: gateway)
    item = { id: '167', name: 'Lobs', price: '145.00', quantity: '3' }
    item_use_case.execute(item_details: item)
    expect(gateway).to have_received(:save) do |item|
      expect(item[1].id).to eq('167')
      expect(item[1].name).to eq('Lobs')
      expect(item[1].price).to eq('145.00')
      expect(item[1].quantity).to eq('3')
    end
  end

  it 'returns an error for missing id' do
    response = use_case.execute(item_details: { id: '', name: 'Bobs', price: '10.00', quantity: '10' })
    expect(response).to eq(
      successful: false,
      errors: [:missing_id]
    )
  end
end
