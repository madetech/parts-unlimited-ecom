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
      expect(response).to eq(successful: true, errors: [])
    end

    it 'can return an error for missing customer_name' do
      response = use_case.execute(customer_details: {
                                    customer_name: '',
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
      expect(response).to eq(successful: false, errors: [:missing_customer_name])
    end

    it 'can return an error for missing shipping address 1' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '',
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
      expect(response).to eq(successful: false, errors: [:missing_shipping_address_line1])
    end

    it 'can return an error for missing shipping_city' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: '',
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
      expect(response).to eq(successful: false, errors: [:missing_shipping_city])
    end

    it 'can return no errors for missing shipping_address line 2' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: '',
                                    shipping_city: 'london',
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
      expect(response).to eq(successful: true, errors: [])
    end

    it 'can return no errors for missing billing_address line 2' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '07912456672',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: '',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '07912456672',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: true, errors: [])
    end

    it 'can return an error for shipping phone number with character' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: 'a7912456672',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '07912456672',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_shipping_phone_number])
    end

    it 'can return an error for shipping phone number outside of length 11-13' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '07912456672112',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '07912456672',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_shipping_phone_number])
    end
    it 'can return an error for billing phone number with character' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '01202345678',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: 'a7912456672',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_billing_phone_number])
    end

    it 'can return an error for billing phone number outside of length 11-13' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '01202452837',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '07912456672112',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_billing_phone_number])
    end

    it 'can return an error for invalid shipping postcode' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: '2N1 0SW',
                                    shipping_phone_number: '01202452837',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '079124566721',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_shipping_postcode])
    end

    it 'can return an error for invalid billing postcode' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '01202452837',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: '2N1 0SW',
                                    billing_phone_number: '079124566721',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_billing_postcode])
    end

    it 'can return an error for invalid shipping email' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '01202452837',
                                    shipping_email_address: 'paulie',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '079124566721',
                                    billing_email_address: 'harry@gmail.com'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_shipping_email_address])
    end

    it 'can return an error for invalid shipping email' do
      response = use_case.execute(customer_details: {
                                    customer_name: 'Harry',
                                    shipping_address_line1: '13 South Street',
                                    shipping_address_line2: 'Borough',
                                    shipping_city: 'london',
                                    shipping_county: 'Manchester',
                                    shipping_postcode: 'N21 0SW',
                                    shipping_phone_number: '01202452837',
                                    shipping_email_address: 'harry@gmail.com',
                                    billing_address_line1: '13 South Street',
                                    billing_address_line2: 'Borough',
                                    billing_city: 'Fake',
                                    billing_county: 'Manchester',
                                    billing_postcode: 'N21 0SW',
                                    billing_phone_number: '079124566721',
                                    billing_email_address: 'paulie'
                                  })
      expect(response).to eq(successful: false, errors: [:invalid_billing_email_address])
    end
  end
end
