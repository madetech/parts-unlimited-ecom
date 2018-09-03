# frozen_string_literal: true

require 'json'

describe 'place order' do
  let(:file_customer_gateway) { FileCustomerGateway.new }

  context 'given valid customer details' do
    it 'stores the customer details' do
      customer_details = {
        customer_name: 'Barry',
        shipping_address_line1: '136 Southwark Street',
        shipping_address_line2: 'Southwark',
        shipping_city: 'London',
        shipping_county: 'Greater London',
        shipping_postcode: 'SE1 0SW',
        shipping_phone_number: '07912345671',
        shipping_email_address: 'barry@gmail.com',
        billing_address_line1: '136 Southwark Street',
        billing_address_line2: 'Southwark',
        billing_city: 'London',
        billing_county: 'Greater London',
        billing_postcode: 'SE1 0SW',
        billing_phone_number: '07912345671',
        billing_email_address: 'barry@gmail.com'
      }

      save_customer_details = SaveCustomerDetails.new(customer_gateway: file_customer_gateway)
      save_customer_details.execute(customer_details: customer_details)

      customer = file_customer_gateway.all.first
      expect(customer.customer_name).to eq('Barry')
      expect(customer.shipping_address_line1).to eq('136 Southwark Street')
      expect(customer.shipping_address_line2).to eq('Southwark')
      expect(customer.shipping_city).to eq('London')
      expect(customer.shipping_county).to eq('Greater London')
      expect(customer.shipping_postcode).to eq('SE1 0SW')
      expect(customer.shipping_phone_number).to eq('07912345671')
      expect(customer.shipping_email_address).to eq('barry@gmail.com')
      expect(customer.billing_address_line1).to eq('136 Southwark Street')
      expect(customer.billing_address_line2).to eq('Southwark')
      expect(customer.billing_city).to eq('London')
      expect(customer.billing_county).to eq('Greater London')
      expect(customer.billing_postcode).to eq('SE1 0SW')
      expect(customer.billing_phone_number).to eq('07912345671')
      expect(customer.billing_email_address).to eq('barry@gmail.com')
    end
  end
end
