# frozen_string_literal: true

describe SaveCustomerDetails do
  it 'uses the customer gateway to save customer details' do
    s = spy
    use_case = described_class.new(customer_gateway: s)
    use_case.execute(customer_details: {
                       customer_name: 'Paul',
                       shipping_address_line1: '137 Southwark Street',
                       shipping_address_line2: 'Northwark',
                       shipping_city: 'Kent',
                       shipping_county: 'Birmingham',
                       shipping_postcode: 'S21 0SW',
                       shipping_phone_number: '07912345672',
                       shipping_email_address: 'paul@gmail.com',
                       billing_address_line1: '137 Southwark Street',
                       billing_address_line2: 'Northwark',
                       billing_city: 'Kent',
                       billing_county: 'Birmingham',
                       billing_postcode: 'S21 0SW',
                       billing_phone_number: '07912345672',
                       billing_email_address: 'paul@gmail.com'
                     })

    expect(s).to have_received(:save) do |customer|
      expect(customer.customer_name).to eq('Paul')
      expect(customer.shipping_address_line1).to eq('137 Southwark Street')
      expect(customer.shipping_address_line2).to eq('Northwark')
      expect(customer.shipping_city).to eq('Kent')
      expect(customer.shipping_county).to eq('Birmingham')
      expect(customer.shipping_postcode).to eq('S21 0SW')
      expect(customer.shipping_phone_number).to eq('07912345672')
      expect(customer.shipping_email_address).to eq('paul@gmail.com')
      expect(customer.billing_address_line1).to eq('137 Southwark Street')
      expect(customer.billing_address_line2).to eq('Northwark')
      expect(customer.billing_city).to eq('Kent')
      expect(customer.billing_county).to eq('Birmingham')
      expect(customer.billing_postcode).to eq('S21 0SW')
      expect(customer.billing_phone_number).to eq('07912345672')
      expect(customer.billing_email_address).to eq('paul@gmail.com')
    end
  end
end
