# frozen_string_literal: true

require 'json'

describe 'place order' do
  let(:customer_gateway) { FileCustomerGateway.new }
  let(:items_gateway) { FileItemsGateway.new }
  let(:save_customer_details) { SaveCustomerDetails.new(customer_gateway: customer_gateway) }
  let(:save_items_details) { SaveItemsDetails.new(items_gateway: items_gateway) }
  let(:calculate_total_cost) { CalculateTotalCost.new(items_gateway: items_gateway) }
  let(:view_summary) { ViewSummary.new(customer_gateway: customer_gateway, items_gateway: items_gateway, calculate_total_cost: calculate_total_cost) }

  before(:each) { items_gateway.delete_all }

  context 'saving customer details' do
    context 'given valid customer details' do
      it 'stores the customer details' do
        customer_details = {
          shipping_customer_name: 'Barry',
          shipping_address_line1: '136 Southwark Street',
          shipping_address_line2: 'Southwark',
          shipping_city: 'London',
          shipping_county: 'Greater London',
          shipping_postcode: 'SE1 0SW',
          shipping_phone_number: '07912345671',
          shipping_email_address: 'barry@gmail.com',
          billing_customer_name: 'Barry',
          billing_address_line1: '136 Southwark Street',
          billing_address_line2: 'Southwark',
          billing_city: 'London',
          billing_county: 'Greater London',
          billing_postcode: 'SE1 0SW',
          billing_phone_number: '07912345671',
          billing_email_address: 'barry@gmail.com'
        }

        save_customer_details.execute(customer_details: customer_details)

        customer = customer_gateway.all.first
        expect(customer.shipping_customer_name).to eq('Barry')
        expect(customer.shipping_address_line1).to eq('136 Southwark Street')
        expect(customer.shipping_address_line2).to eq('Southwark')
        expect(customer.shipping_city).to eq('London')
        expect(customer.shipping_county).to eq('Greater London')
        expect(customer.shipping_postcode).to eq('SE1 0SW')
        expect(customer.shipping_phone_number).to eq('07912345671')
        expect(customer.shipping_email_address).to eq('barry@gmail.com')
        expect(customer.billing_customer_name).to eq('Barry')
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
          shipping_customer_name: '',
          shipping_address_line1: '',
          shipping_address_line2: 'Hey',
          shipping_city: '',
          shipping_county: '',
          shipping_postcode: 'S2E1 0SW',
          shipping_phone_number: '07912345671765',
          shipping_email_address: 'barrygmail.com',
          billing_customer_name: '',
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
              missing_shipping_customer_name
              missing_shipping_address_line1
              missing_shipping_city
              missing_shipping_county
              missing_billing_customer_name
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
        shipping_customer_name: 'Barry',
        shipping_address_line1: '136 Southwark Street',
        shipping_address_line2: 'Southwark',
        shipping_city: 'London',
        shipping_county: 'Greater London',
        shipping_postcode: 'SE1 0SW',
        shipping_phone_number: '07912345671',
        shipping_email_address: 'barry@gmail.com',
        billing_customer_name: 'Barry',
        billing_address_line1: '136 Southwark Street',
        billing_address_line2: 'Southwark',
        billing_city: 'London',
        billing_county: 'Greater London',
        billing_postcode: 'SE1 0SW',
        billing_phone_number: '07912345671',
        billing_email_address: 'barry@gmail.com'
      }
      item1 = { id: '456', name: 'Drones', price: '144', quantity: '34', total: '4896.00' }
      item2 = { id: '454', name: 'Uranium', price: '130', quantity: '100', total: '13000.00' }
      item3 = { id: '767', name: 'ACHSDJVHJDWVVFWVYEUVFW', price: '10', quantity: '200000', total: '2000000.00' }
      item4 = { id: '999', name: 'Screws', price: '0.9', quantity: '2000', total: '1800.00' }

      save_customer_details.execute(customer_details: customer_details)
      save_items_details.execute(item_details: item1)
      save_items_details.execute(item_details: item2)
      save_items_details.execute(item_details: item3)
      save_items_details.execute(item_details: item4)

      response = view_summary.execute
      expect(response).to eq(customer: customer_details, items: [item1, item2, item3, item4], net_total: '2019696.00')
    end
  end

  context 'add items' do
    context 'given valid item detais' do
      it 'stores the item details' do
        item_ordered = { id: '123', name: 'Bits', price: '5.00', quantity: '1' }
        save_items_details.execute(item_details: item_ordered)

        item = view_summary.execute[:items].first

        expect(item[:id]).to eq('123')
        expect(item[:name]).to eq('Bits')
        expect(item[:price]).to eq('5.00')
        expect(item[:quantity]).to eq('1')
      end

      it 'stores the multiple items details' do
        ordered_item1 = { id: '233', name: 'Bats', price: '12.00', quantity: '4' }
        ordered_item2 = { id: '343', name: 'Buts', price: '17.00', quantity: '10' }

        save_items_details.execute(item_details: ordered_item1)
        save_items_details.execute(item_details: ordered_item2)

        items = view_summary.execute[:items]

        expect(items[0][:id]).to eq('233')
        expect(items[0][:name]).to eq('Bats')
        expect(items[0][:price]).to eq('12.00')
        expect(items[0][:quantity]).to eq('4')
        expect(items[1][:id]).to eq('343')
        expect(items[1][:name]).to eq('Buts')
        expect(items[1][:price]).to eq('17.00')
        expect(items[1][:quantity]).to eq('10')
      end

      it 'can delete a item row by index' do
        ordered_item1 = { id: '233', name: 'Bats', price: '12.00', quantity: '4' }
        ordered_item2 = { id: '343', name: 'Buts', price: '17.00', quantity: '10' }
        ordered_item3 = { id: '33', name: 'Bits', price: '1.00', quantity: '10' }

        save_items_details.execute(item_details: ordered_item1)
        save_items_details.execute(item_details: ordered_item2)
        save_items_details.execute(item_details: ordered_item3)

        items = items_gateway.all
        expect(items.count).to eq(3)

        items_gateway.delete_item_at(0)
        items = items_gateway.all
        expect(items.count).to eq(2)

        expect(items[0].id).to eq('343')
        expect(items[0].name).to eq('Buts')
        expect(items[0].price).to eq('17.00')
        expect(items[0].quantity).to eq('10')
        expect(items[1].id).to eq('33')
        expect(items[1].name).to eq('Bits')
        expect(items[1].price).to eq('1.00')
        expect(items[1].quantity).to eq('10')
      end
    end

    context 'given invalid items details' do
      it 'responds with a validation error' do
        ordered_item = { id: '', name: '', price: 'efefger', quantity: 'ergre' }

        response = save_items_details.execute(item_details: ordered_item)
        expect(response).to eq(
          successful: false,
          errors: %i[
            missing_id
            missing_name
            invalid_price
            invalid_quantity
          ]
        )
      end
    end

    context 'calculating the total price of items' do
      it 'would return a number as its total' do
        ordered_item = { id: '233', name: 'Bats', price: '7.00', quantity: '4' }
        save_items_details.execute(item_details: ordered_item)

        response = calculate_total_cost.execute
        expect(response).to eq('28.00')
      end

      it 'retrieves the total calculated cost of the summary' do
        ordered_item1 = { id: '233', name: 'Bats', price: '12.00', quantity: '10' }
        ordered_item2 = { id: '343', name: 'Bets', price: '1.20', quantity: '1' }
        ordered_item3 = { id: '343', name: 'Bits', price: '5.00', quantity: '5' }
        ordered_item4 = { id: '343', name: 'Bots', price: '4.30', quantity: '1' }
        ordered_item5 = { id: '343', name: 'Buts', price: '4.00', quantity: '4' }

        save_items_details.execute(item_details: ordered_item1)
        save_items_details.execute(item_details: ordered_item2)
        save_items_details.execute(item_details: ordered_item3)
        save_items_details.execute(item_details: ordered_item4)
        save_items_details.execute(item_details: ordered_item5)

        response = calculate_total_cost.execute

        expect(response).to eq('166.50')
      end
    end
  end

  context 'delete item' do
    it 'deletes an item' do
      item = { id: '123', name: 'Bits', price: '5.00', quantity: '1' }
      save_items_details.execute(item_details: item)
      delete_item = DeleteItem.new(items_gateway: items_gateway)
      delete_item.execute(index: 0)
      expect(view_summary.execute[:items]).to eq([])
    end
  end
end
