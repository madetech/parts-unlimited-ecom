# frozen_string_literal: true

describe SaveItemsDetails do
  let(:items_gateway) { spy(all: []) }
  let(:dummy_item) { Class.new }
  let(:use_case) { described_class.new(items_gateway: items_gateway) }

  it 'uses the items gateway to save the order details' do
    item = { product_code: '456', name: 'Bots', price: '10.00', quantity: '2' }
    use_case.execute(item_details: item)
    expect(items_gateway).to have_received(:save) do |item|
      expect(item.product_code).to eq('456')
      expect(item.name).to eq('Bots')
      expect(item.price).to eq('10.00')
      expect(item.quantity).to eq('2')
    end
  end

  it 'returns an error for missing product_code' do
    response = use_case.execute(item_details: { product_code: '', name: 'Bobs', price: '10.00', quantity: '10' })
    expect(response).to eq(
      successful: false,
      errors: [:missing_product_code]
    )
  end

  it 'returns an error for invalid price' do
    response = use_case.execute(item_details: { product_code: '12', name: 'Bobs', price: 'bits', quantity: '10' })
    expect(response).to eq(
      successful: false,
      errors: [:invalid_price]
    )
  end

  it 'returns an error for a different invalid price' do
    response = use_case.execute(item_details: { product_code: '12', name: 'Bobs', price: '10.90l', quantity: '10' })
    expect(response).to eq(
      successful: false,
      errors: [:invalid_price]
    )
  end

  it 'returns an error for invalid quantity' do
    response = use_case.execute(item_details: { product_code: '12', name: 'Bobs', price: '12.00', quantity: 'Bots' })
    expect(response).to eq(
      successful: false,
      errors: [:invalid_quantity]
    )
  end
end
