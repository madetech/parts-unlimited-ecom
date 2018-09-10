# frozen_string_literal: true

describe SaveItemsDetails do
  let(:items_gateway) { spy }
  let(:use_case) do
    described_class.new(items_gateway: items_gateway)
  end

  it 'uses the items gateway to save the order details' do
    use_case.execute(items: [{
                       id: '456',
                       name: 'Bots',
                       price: '10.00',
                       quantity: '2'
                     }])
    expect(items_gateway).to have_received(:save) do |items|
      expect(items[0].id).to eq('456')
      expect(items[0].name).to eq('Bots')
      expect(items[0].price).to eq('10.00')
      expect(items[0].quantity).to eq('2')
    end
  end

  it 'uses the items gateway to save multiple rows' do
    items = [
      { id: '999', name: 'Bobs', price: '99.00', quantity: '25' },
      { id: '167', name: 'Lobs', price: '145.00', quantity: '3' }
    ]
    use_case.execute(items: items)
    expect(items_gateway).to have_received(:save) do |items|
      expect(items[0].id).to eq('999')
      expect(items[0].name).to eq('Bobs')
      expect(items[0].price).to eq('99.00')
      expect(items[0].quantity).to eq('25')
      expect(items[1].id).to eq('167')
      expect(items[1].name).to eq('Lobs')
      expect(items[1].price).to eq('145.00')
      expect(items[1].quantity).to eq('3')
    end
  end

  it 'returns an error for missing id' do
    response = use_case.execute(items: [
                                  { id: '', name: 'Bobs', price: '10.00', quantity: '10' }
                                ])
    expect(response).to eq(successful: false,
                           errors: [
                             [:missing_id, 0]
                           ])
  end

  it 'returns an error for multiple invalid rows' do
    response = use_case.execute(items: [
                                  { id: '14', name: '', price: '10.00', quantity: '10' },
                                  { id: '', name: '', price: '10.00', quantity: '10' }
                                ])
    expect(response).to eq(successful: false,
                           errors: [
                             [:missing_name, 0],
                             [:missing_id, 1],
                             [:missing_name, 1]
                           ])
  end
end
