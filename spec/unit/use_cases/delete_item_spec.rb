# frozen_string_literal: true

describe DeleteItem do
  it 'deletes an item' do
    items_gateway = spy
    item_deleter = DeleteItem.new(items_gateway: items_gateway)
    item_deleter.execute(index: 0)
    expect(items_gateway).to have_received(:delete_item_at).with(0)
  end

  it 'return an empty hash' do
    items_gateway = spy
    item_deleter = DeleteItem.new(items_gateway: items_gateway)
    response = item_deleter.execute(index: 0)
    expect(response).to eq({})
  end
end
