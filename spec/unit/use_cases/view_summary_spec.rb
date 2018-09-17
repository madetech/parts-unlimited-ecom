# frozen_string_literal: true

describe ViewSummary do
  let(:file_customer_gateway) { spy }
  let(:file_items_gateway) { spy }
  let(:calculate_total_cost) { spy }
  let(:view_summary) do
    described_class.new(
      customer_gateway: file_customer_gateway,
      items_gateway: file_items_gateway,
      calculate_total_cost: calculate_total_cost
    )
  end

  class Stub
    def initialize(id, name, price, quantity, total)
      @total = total
      @id = id
      @price = price
      @quantity = quantity
      @name = name
    end

    attr_reader :id, :name, :price, :quantity, :total
  end

  class CustomerStub
    def initialize(
      shipping_customer_name,
      shipping_address_line1,
      shipping_city,
      shipping_county,
      shipping_postcode,
      shipping_phone_number,
      shipping_email_address,
      billing_customer_name,
      billing_address_line1,
      billing_city,
      billing_county,
      billing_postcode,
      billing_phone_number,
      billing_email_address
    )
      @shipping_customer_name = shipping_customer_name
      @shipping_address_line1 = shipping_address_line1
      @shipping_city = shipping_city
      @shipping_county = shipping_county
      @shipping_postcode = shipping_postcode
      @shipping_phone_number = shipping_phone_number
      @shipping_email_address = shipping_email_address
      @billing_customer_name = billing_customer_name
      @billing_address_line1 = billing_address_line1
      @billing_city = billing_city
      @billing_county = billing_county
      @billing_postcode = billing_postcode
      @billing_phone_number = billing_phone_number
      @billing_email_address = billing_email_address
    end

    attr_reader :shipping_customer_name,
                :shipping_address_line1,
                :shipping_address_line2,
                :shipping_city,
                :shipping_county,
                :shipping_postcode,
                :shipping_phone_number,
                :shipping_email_address,
                :billing_customer_name,
                :billing_address_line1,
                :billing_address_line2,
                :billing_city,
                :billing_county,
                :billing_postcode,
                :billing_phone_number,
                :billing_email_address
  end

  it 'uses the gateway to retrieve the details' do
    customer_double = double(all: [CustomerStub.new(
      'Harry',
      'Southwark',
      'London',
      'Greater London',
      'LN1 2DZ',
      '01234567890',
      'harry@southwark.com',
      'Harry',
      'Southwark',
      'London',
      'Greater London',
      'LN1 2DZ',
      '01234567890',
      'harry@southwark.com'
    )])
    view_summary = described_class.new(
      customer_gateway: customer_double,
      items_gateway: spy,
      calculate_total_cost: spy
    )
    response = view_summary.execute
    expect(response[:customer]).to eq(
      billing_address_line1: 'Southwark',
      billing_address_line2: nil,
      billing_city: 'London',
      billing_county: 'Greater London',
      billing_email_address: 'harry@southwark.com',
      shipping_phone_number: '01234567890',
      shipping_postcode: 'LN1 2DZ',
      billing_phone_number: '01234567890',
      billing_postcode: 'LN1 2DZ',
      shipping_customer_name: 'Harry',
      billing_customer_name: 'Harry',
      shipping_address_line1: 'Southwark',
      shipping_address_line2: nil,
      shipping_city: 'London',
      shipping_county: 'Greater London',
      shipping_email_address: 'harry@southwark.com'
    )
  end

  it 'returns items' do
    view_summary = described_class.new(
      customer_gateway: spy,
      items_gateway: double(all: [Stub.new('113', 'Billy Bob', '12', '2', '24')]),
      calculate_total_cost: spy
    )
    response = view_summary.execute
    expected_items = [{
      id: '113',
      name: 'Billy Bob',
      price: '12',
      quantity: '2',
      total: '24.00'
    }]
    expect(response[:items]).to eq(expected_items)
  end

  it 'returns net total' do
    view_summary = described_class.new(
      customer_gateway: spy,
      items_gateway: spy,
      calculate_total_cost: double(execute: '50.00')
    )
    response = view_summary.execute
    expect(response[:net_total]).to eq('50.00')
  end
end
