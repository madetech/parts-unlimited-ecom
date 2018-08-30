# frozen_string_literal: true

describe FileCustomerGateway do
  before do 
    file_customer_gateway = described_class.new
    file_customer_gateway.delete_all
  end
  
  it 'can get no customers' do
    file_customer_gateway = described_class.new
    expect(file_customer_gateway.all).to eq([])
  end

  it 'can get a customer' do
    file_customer_gateway = described_class.new
    customer = Customer.new
    customer.customer_name = 'Bob'
    customer.shipping_address_line1 = '1 Fake Street'
    customer.shipping_address_line2 = 'Fake Flat'
    customer.shipping_city = 'Faketon'
    customer.shipping_county = 'Fakeshire'
    customer.shipping_postcode = 'FK1 1SW'
    customer.shipping_phone_number = '018283818283'
    customer.shipping_email_address = 'fake@gmail.com'
    customer.billing_address_line1 = '12 Fakeish'
    customer.billing_address_line2 = 'Fake block'
    customer.billing_city = 'Fakeville'
    customer.billing_county = 'Fakeishshire'
    customer.billing_postcode = 'FK2 1EE'
    customer.billing_phone_number = '01982371'
    customer.billing_email_address = 'fake2@gmail.com'
    file_customer_gateway.save(customer)

    file_customer_gateway.all.first.tap do |customer|
      expect(customer.customer_name).to eq('Bob')
      expect(customer.shipping_address_line1).to eq('1 Fake Street')
      expect(customer.shipping_address_line2).to eq('Fake Flat')
      expect(customer.shipping_city).to eq('Faketon')
      expect(customer.shipping_county).to eq('Fakeshire')
      expect(customer.shipping_postcode).to eq('FK1 1SW')
      expect(customer.shipping_phone_number).to eq('018283818283')
      expect(customer.shipping_email_address).to eq('fake@gmail.com')
      expect(customer.billing_address_line1).to eq('12 Fakeish')
      expect(customer.billing_address_line2).to eq('Fake block')
      expect(customer.billing_city).to eq('Fakeville')
      expect(customer.billing_county).to eq('Fakeishshire')
      expect(customer.billing_postcode).to eq('FK2 1EE')
      expect(customer.billing_phone_number).to eq('01982371')
      expect(customer.billing_email_address).to eq('fake2@gmail.com')
    end
  end
end
