# frozen_string_literal: true

require 'json'

describe 'place order' do
  let(:file_customer_gateway) { FileCustomerGateway.new }
  let(:save_customer_details) { SaveCustomerDetails.new(customer_gateway: file_customer_gateway) }

  context 'saving customer details' do
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

    context 'given invalid customer details' do
      it 'responds with a validation error' do
        customer_details = {
          customer_name: '',
          shipping_address_line1: '',
          shipping_address_line2: 'Hey',
          shipping_city: '',
          shipping_county: '',
          shipping_postcode: 'S2E1 0SW',
          shipping_phone_number: '07912345671765',
          shipping_email_address: 'barrygmail.com',
          billing_address_line1: '',
          billing_address_line2: 'Southwark',
          billing_city: '',
          billing_county: '',
          billing_postcode: '111 0SW',
          billing_phone_number: '079a1345671',
          billing_email_address: '@gmail.com'
        }
        response = save_customer_details.execute(customer_details: customer_details)
        expect(response).to(
          eq(
            successful: false,
            errors: %i[
              missing_customer_name
              missing_shipping_address_line1
              missing_shipping_city
              missing_shipping_county
              missing_billing_address_line1
              missing_billing_city
              missing_billing_county
              invalid_shipping_phone_number
              invalid_billing_phone_number
              invalid_shipping_postcode
              invalid_billing_postcode
              invalid_shipping_email_address
              invalid_billing_email_address
            ]
          )
        )
      end
    end
  end

  context 'viewing order summary'  do
    it 'displays customer details' do
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

      save_customer_details.execute(customer_details: customer_details)
      view_summary = ViewSummary.new(customer_gateway: file_customer_gateway, items_gateway: spy)
      response = view_summary.execute
      expect(response[:customer]).to eq(customer_details)
    end
  end
end
