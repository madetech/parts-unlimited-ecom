# frozen_string_literal: true

describe ViewSummary do
  let(:file_customer_gateway) { spy }
  let(:file_items_gateway) { spy }
  let(:view_summary) { described_class.new(customer_gateway: file_customer_gateway, items_gateway: file_items_gateway) }

  it 'uses the gateway to retrieve the details' do
    view_summary.execute
    expect(file_customer_gateway).to have_received(:all)
  end

  it 'uses the gateway to retrieve items' do
    view_summary.execute
    expect(file_items_gateway).to have_received(:all)
  end

  it 'returns items' do
    response = view_summary.execute
    expect(response.key?(:items)).to be(true)
  end
end
