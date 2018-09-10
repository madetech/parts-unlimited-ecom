# frozen_string_literal: true

require 'json'

describe 'customer details' do
  let(:file_customer_gateway) { FileCustomerGateway.new }
  let(:file_items_gateway) { FileItemsGateway.new }
  let(:save_customer_details) { SaveCustomerDetails.new(customer_gateway: file_customer_gateway) }
  let(:save_items_details) { SaveItemsDetails.new(items_gateway: file_items_gateway) }

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

      items = [
        { id: '456', name: 'Drones', price: '144', quantity: '34' },
        { id: '454', name: 'Uranium', price: '130', quantity: '100' },
        { id: '767', name: 'ACHSDJVHJDWVVFWVYEUVFW', price: '10', quantity: '200000' },
        { id: '999', name: 'Screws', price: '0.9', quantity: '2000' }
      ]

      save_customer_details.execute(customer_details: customer_details)
      save_items_details.execute(items: items)

      view_summary = ViewSummary.new(customer_gateway: file_customer_gateway, items_gateway: file_items_gateway)
      response = view_summary.execute
      expect(response).to eq(customer: customer_details, items: items)
    end
  end
end

describe 'add items' do
  let(:items_gateway) { FileItemsGateway.new }
  let(:save_items_details) { SaveItemsDetails.new(items_gateway: items_gateway) }

  context 'given valid item detais' do
    it 'stores the item details' do
      ordered_items = [{
        id: '123',
        name: 'Bits',
        price: '5.00',
        quantity: '1'
      }]
      save_items_details.execute(items: ordered_items)

      items = items_gateway.all.first

      expect(items[0].id).to eq('123')
      expect(items[0].name).to eq('Bits')
      expect(items[0].price).to eq('5.00')
      expect(items[0].quantity).to eq('1')
    end

    it 'stores the multiple items details' do
      ordered_items = [
        { id: '233', name: 'Bats', price: '12.00', quantity: '4' },
        { id: '343', name: 'Buts', price: '17.00', quantity: '10' }
      ]

      save_items_details.execute(items: ordered_items)

      items = items_gateway.all.first

      expect(items[0].id).to eq('233')
      expect(items[0].name).to eq('Bats')
      expect(items[0].price).to eq('12.00')
      expect(items[0].quantity).to eq('4')
      expect(items[1].id).to eq('343')
      expect(items[1].name).to eq('Buts')
      expect(items[1].price).to eq('17.00')
      expect(items[1].quantity).to eq('10')
    end
  end

  context 'given invalid items details' do
    it 'responds with a validation error' do
      ordered_items = [
        { id: '', name: '', price: '', quantity: '' }
      ]
      response = save_items_details.execute(items: ordered_items)
      expect(response).to eq(
        successful: false,
        errors: [
          [:missing_id, 0],
          [:missing_name, 0],
          [:missing_price, 0],
          [:missing_quantity, 0]
        ]
      )
    end
  end
end
