# frozen_string_literal: true

describe DuplicateAddress do
  context 'given just a shipping address' do
    it 'will copy it to the billing address' do
      customer_details = {
        shipping_customer_name: 'Bill Bobby',
        shipping_address_line1: 'On top of a lampost',
        shipping_address_line2: 'third right after sainsburys',
        shipping_city: 'by the big part',
        shipping_county: 'south of the river',
        shipping_postcode: 'LP3 WT4',
        shipping_phone_number: '01234567890',
        shipping_email_address: 'billy_the_bob@lamppost-by-the-river.com'
      }
      save_customer_details = spy
      duplicate_address = DuplicateAddress.new(save_customer_details: save_customer_details)

      duplicate_address.execute(customer_details: customer_details)
      
      expect(save_customer_details).to have_received(:execute).with(
        customer_details: {
          shipping_customer_name: 'Bill Bobby',
          shipping_address_line1: 'On top of a lampost',
          shipping_address_line2: 'third right after sainsburys',
          shipping_city: 'by the big part',
          shipping_county: 'south of the river',
          shipping_postcode: 'LP3 WT4',
          shipping_phone_number: '01234567890',
          shipping_email_address: 'billy_the_bob@lamppost-by-the-river.com',
          billing_customer_name: 'Bill Bobby',
          billing_address_line1: 'On top of a lampost',
          billing_address_line2: 'third right after sainsburys',
          billing_city: 'by the big part',
          billing_county: 'south of the river',
          billing_postcode: 'LP3 WT4',
          billing_phone_number: '01234567890',
          billing_email_address: 'billy_the_bob@lamppost-by-the-river.com'
        }
      )
    end
  end
end
