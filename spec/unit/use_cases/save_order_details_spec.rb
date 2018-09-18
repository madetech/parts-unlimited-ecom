describe SaveOrderDetails do
  let(:order_gateway) { spy }
  let(:dummy_item) { Class.new }
  let(:use_case) { described_class.new(order_gateway: order_gateway) }

  it 'uses the order gateway to save the shipping total' do
    use_case.execute(order_details: { shipping_total: '24.00' })
    expect(order_gateway).to have_received(:save) do |order|
      expect(order.shipping_total).to eq('24.00')
    end
  end
end
