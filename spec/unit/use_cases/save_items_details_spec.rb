# frozen_string_literal: true

describe SaveItemsDetails do
  let(:items_gateway) { spy }
  let(:use_case) do
    described_class.new(items_gateway: items_gateway)
  end

  it 'uses the items gateway to save the order details' do
    use_case.execute(items_details: [{ part_id: '456', part_name: 'Bots', part_price: '10.00', part_quantity: '2' }])
    expect(items_gateway).to have_received(:save).with([{ part_id: '456', part_name: 'Bots', part_price: '10.00', part_quantity: '2' }])
  end

  it 'uses the items gateway to save multiple rows' do
    items_details = [
      { part_id: '999', part_name: 'Bobs', part_price: '99.00', part_quantity: '25' },
      { part_id: '167', part_name: 'Lobs', part_price: '145.00', part_quantity: '3' }
    ]
    use_case.execute(items_details: items_details)
    expect(items_gateway).to have_received(:save).with(items_details)
  end

  it 'returns an error for missing part id' do
    response = use_case.execute(items_details: [
        { part_id: '', part_name: 'Bobs', part_price: '10.00', part_quantity: '10' }
      ])
    expect(response).to eq(successful: false,
                           errors: [
                             [:missing_part_id, 0]
                           ])
  end

  it 'returns an error for multiple invalid rows' do
    response = use_case.execute(items_details: [
        { part_id: '14', part_name: '', part_price: '10.00', part_quantity: '10' },
        { part_id: '', part_name: '', part_price: '10.00', part_quantity: '10' }
      ])
    expect(response).to eq(successful: false,
                           errors: [
                             [:missing_part_name, 0],
                             [:missing_part_id, 1],
                             [:missing_part_name, 1]
                           ])
  end
end
