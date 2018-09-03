# frozen_string_literal: true

describe SaveCustomerDetails do

  let(:customer_gateway) { spy }
  let(:use_case) do
    described_class.new(customer_gateway: customer_gateway)
  end 

  it 'uses the customer gateway to save customer details' do
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

    expect(customer_gateway).to have_received(:save) do |customer|
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

  context 'validate customer details' do 
    it 'can return success for valid details' do
      response = use_case.execute(customer_details: {
                       customer_name: 'Harry',
                       shipping_address_line1: '13 South Street',
                       shipping_address_line2: 'Borough',
                       shipping_city: 'Fake',
                       shipping_county: 'Manchester',
                       shipping_postcode: 'N21 0SW',
                       shipping_phone_number: '07912456672',
                       shipping_email_address: 'harry@gmail.com',
                       billing_address_line1: '13 South Street',
                       billing_address_line2: 'Borough',
                       billing_city: 'Fake',
                       billing_county: 'Manchester',
                       billing_postcode: 'N21 0SW',
                       billing_phone_number: '07912456672',
                       billing_email_address: 'harry@gmail.com'
                     })
      expect(response).to eq({successful: true, errors: []})
    end 
  end 
end
