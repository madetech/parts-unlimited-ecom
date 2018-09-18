# frozen_string_literal: true

describe FileOrderGateway do
  let(:file_order_gateway) { described_class.new }

  before do
    file_order_gateway.delete_all
  end

  it 'can get no order' do
    expect(file_order_gateway.all).to eq([])
  end

  it 'can get shipping total from order' do
    order_builder = Builder::Order.new

    order_builder.order_details = { shipping_total: '12.00' }
    
    order = order_builder.build
    file_order_gateway.save(order)

    file_order_gateway.all.first.tap do |order|
      expect(order.shipping_total).to eq('12.00')
    end
  end
end
