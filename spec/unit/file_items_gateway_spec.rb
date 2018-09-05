describe FileItemsGateway do
  let(:file_items_gateway) { described_class.new }

  before do
    file_items_gateway.delete_all
  end

  it 'can get no items' do
    expect(file_items_gateway.all).to eq([])
  end

  it 'can get a row of item details' do
    items = [{ part_id: '108', part_name: 'Jeremy', part_price: 28, part_quantity: 1 }]
    file_items_gateway.save(items)
    expect(file_items_gateway.all).to eq([{ part_id: '108', part_name: 'Jeremy', part_price: 28, part_quantity: 1 }])
  end
end
