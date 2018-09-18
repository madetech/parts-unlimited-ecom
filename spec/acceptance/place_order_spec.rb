# frozen_string_literal: true

require 'json'

describe 'place order' do
  database = DatabaseAdministrator::Postgres.new.existing_database
  let(:customer_gateway) { FileCustomerGateway.new(database: database) }
  let(:items_gateway) { FileItemsGateway.new(database: database) }
  let(:save_customer_details) { SaveCustomerDetails.new(customer_gateway: customer_gateway) }
  let(:save_items_details) { SaveItemsDetails.new(items_gateway: items_gateway) }
  let(:calculate_total_cost) { CalculateTotalCost.new(items_gateway: items_gateway) }
  let(:duplicate_address) { DuplicateAddress.new(save_customer_details: save_customer_details) }
  let(:delete_item) { DeleteItem.new(items_gateway: items_gateway) }
  let(:calculate_vat) { CalculateVAT.new(items_gateway: items_gateway) }
  let(:view_summary) { ViewSummary.new(customer_gateway: customer_gateway, items_gateway: items_gateway, calculate_total_cost: calculate_total_cost, calculate_vat: calculate_vat) }

  before(:each) do
    items_gateway.delete_all
  end

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

    context 'given a shipping address to be duplicated' do
      it 'duplicates then stores the address' do
        customer_details = {
          shipping_customer_name: 'Harry',
          shipping_address_line1: 'Boo',
          shipping_address_line2: 'Scary',
          shipping_city: 'CatVille',
          shipping_county: 'GLondon',
          shipping_postcode: 'SE1 0SW',
          shipping_phone_number: '07912345671',
          shipping_email_address: 'barry@gmail.com'
        }
        response = duplicate_address.execute(customer_details: customer_details)
        summary = view_summary.execute
        expect(response).to eq(errors: [], successful: true)
        expect(summary[:customer]).to eq(customer_details)
      end

      it 'wont save invalid customer details after duplication' do
        customer_details = {
          shipping_customer_name: 'Paul',
          shipping_address_line1: 'House',
          shipping_address_line2: 'Street',
          shipping_city: '',
          shipping_county: 'County',
          shipping_postcode: 'SE1 0SW',
          shipping_phone_number: '07912345671',
          shipping_email_address: 'barry@gmail.com'
        }
        response = duplicate_address.execute(customer_details: customer_details)
        summary = view_summary.execute
        expect(response).to eq(errors: %i[missing_shipping_city missing_billing_city], successful: false)
        expect(summary[:customer]).not_to eq(customer_details)
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

      ordered_item1 = { product_code: '233', name: 'Bats', price: '12.00', quantity: '4' }
      ordered_item2 = { product_code: '343', name: 'Buts', price: '17.00', quantity: '10' }

      save_customer_details.execute(customer_details: customer_details)
      save_items_details.execute(item_details: ordered_item1)
      save_items_details.execute(item_details: ordered_item2)

      items = view_summary.execute[:items]
      response = view_summary.execute

      expect(response).to include(customer: customer_details)
      expect(items[0][:product_code]).to eq('233')
      expect(items[0][:name]).to eq('Bats')
      expect(items[0][:price]).to eq('12.00')
      expect(items[0][:quantity]).to eq('4')
      expect(items[1][:product_code]).to eq('343')
      expect(items[1][:name]).to eq('Buts')
      expect(items[1][:price]).to eq('17.00')
      expect(items[1][:quantity]).to eq('10')

      expect(response).to include(net_total: '218.00')
      expect(response).to include(vat_total: '403939.20')
    end
  end

  context 'add items' do
    context 'given valid item detais' do
      it 'stores the item details' do
        item_ordered = { product_code: '123', name: 'Bits', price: '5.00', quantity: '1' }
        save_items_details.execute(item_details: item_ordered)

        item = view_summary.execute[:items].first

        expect(item[:product_code]).to eq('123')
        expect(item[:name]).to eq('Bits')
        expect(item[:price]).to eq('5.00')
        expect(item[:quantity]).to eq('1')
      end

      it 'can delete a item row by index' do
        ordered_item1 = { product_code: '233', name: 'Bats', price: '12.00', quantity: '4' }
        ordered_item2 = { product_code: '343', name: 'Buts', price: '17.00', quantity: '10' }
        ordered_item3 = { product_code: '33', name: 'Bits', price: '1.00', quantity: '10' }

        save_items_details.execute(item_details: ordered_item1)
        save_items_details.execute(item_details: ordered_item2)
        save_items_details.execute(item_details: ordered_item3)

        items = view_summary.execute[:items]
        expect(items.count).to eq(3)

        delete_item.execute(id: items.first[:id])
        new_items = view_summary.execute[:items]
        item_1, item_2 = new_items

        expect(new_items.count).to eq(2)

        expect(item_1[:product_code]).to eq('343')
        expect(item_1[:name]).to eq('Buts')
        expect(item_1[:price]).to eq('17.00')
        expect(item_1[:quantity]).to eq('10')
        expect(item_2[:product_code]).to eq('33')
        expect(item_2[:name]).to eq('Bits')
        expect(item_2[:price]).to eq('1.00')
        expect(item_2[:quantity]).to eq('10')
      end
    end

    context 'given invalid items details' do
      it 'responds with a validation error' do
        ordered_item = { product_code: '', name: '', price: 'efefger', quantity: 'ergre' }

        response = save_items_details.execute(item_details: ordered_item)
        expect(response).to eq(
          successful: false,
          errors: %i[
            missing_product_code
            missing_name
            invalid_price
            invalid_quantity
          ]
        )
      end
    end

    context 'calculating the total price of items' do
      it 'would return a number as its total' do
        ordered_item = { product_code: '233', name: 'Bats', price: '7.00', quantity: '4' }
        save_items_details.execute(item_details: ordered_item)

        response = calculate_total_cost.execute
        expect(response).to eq('28.00')
      end

      it 'retrieves the total calculated cost of the summary' do
        ordered_item1 = { product_code: '233', name: 'Bats', price: '12.00', quantity: '10' }
        ordered_item2 = { product_code: '343', name: 'Bets', price: '1.20', quantity: '1' }
        ordered_item3 = { product_code: '343', name: 'Bits', price: '5.00', quantity: '5' }
        ordered_item4 = { product_code: '343', name: 'Bots', price: '4.30', quantity: '1' }
        ordered_item5 = { product_code: '343', name: 'Buts', price: '4.00', quantity: '4' }

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

    context 'calculating the vat total of total items' do
      it 'returns the vat total of items' do
        ordered_item1 = { id: '23', name: 'Bats', price: '10.00', quantity: '10' }
        ordered_item2 = { id: '24', name: 'Bets', price: '12.20', quantity: '1' }
        ordered_item3 = { id: '33', name: 'Bits', price: '15.00', quantity: '5' }
        ordered_item4 = { id: '34', name: 'Bots', price: '4.00', quantity: '1' }
        ordered_item5 = { id: '43', name: 'Buts', price: '10.00', quantity: '4' }

        save_items_details.execute(item_details: ordered_item1)
        save_items_details.execute(item_details: ordered_item2)
        save_items_details.execute(item_details: ordered_item3)
        save_items_details.execute(item_details: ordered_item4)
        save_items_details.execute(item_details: ordered_item5)

        response = calculate_vat.execute

        expect(response).to eq('46.24')
      end 
    end 

  context 'delete item' do

    it 'deletes an item' do
      item = { product_code: '123', name: 'Bits', price: '5.00', quantity: '1' }
      save_items_details.execute(item_details: item)
      delete_item = DeleteItem.new(items_gateway: items_gateway)
      delete_item.execute(id: view_summary.execute[:items].first[:id])
      expect(view_summary.execute[:items]).to eq([])
    end
  end
end
