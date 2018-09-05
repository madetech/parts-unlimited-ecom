# frozen_string_literal: true

require 'json'

describe 'customer details' do
  let(:file_customer_gateway) { FileCustomerGateway.new }
  let(:save_customer_details) { SaveCustomerDetails.new(customer_gateway: file_customer_gateway) }

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

  context('given invalid customer details') do
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

describe 'add items' do
  let(:items_gateway) { FileItemsGateway.new }
  let(:save_items_details) { SaveItemsDetails.new(items_gateway: items_gateway) }

  context 'given valid item detais' do
    it 'stores the item details' do
      items_details = [
        { part_id: '123', part_name: 'Bits', part_price: 5, part_quantity: 1 }
      ]
      save_items_details.execute(items_details: items_details)
      items = items_gateway.all
      expect(items).to eq([
        { part_id: '123', part_name: 'Bits', part_price: 5, part_quantity: 1 }
      ])
    end

    it 'stores the multiple items details' do
      items_details = [
        { part_id: '233', part_name: 'Bats', part_price: 12, part_quantity: 4 },
        { part_id: '343', part_name: 'Buts', part_price: 17, part_quantity: 10 }
      ]
      save_items_details.execute(items_details: items_details)
      items = items_gateway.all
      expect(items).to eq([
        { part_id: '233', part_name: 'Bats', part_price: 12, part_quantity: 4 },
        { part_id: '343', part_name: 'Buts', part_price: 17, part_quantity: 10 }
      ])
    end
  end

  context 'given invalid items details' do
    it 'responds with a validation error' do
      items_details = [
        { part_id: '', part_name: '', part_price: 0, part_quantity: 0 }
      ]
      response = save_items_details.execute(items_details: items_details)
      expect(response).to eq(
        successful: false,
        errors: [
          [:missing_part_id, 0],
          [:missing_part_name, 0],
          [:missing_part_price, 0],
          [:missing_part_quantity, 0]
        ])
    end
  end
end
