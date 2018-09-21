# frozen_string_literal: true

describe SequelCustomerGateway do
  database = DatabaseAdministrator::Postgres.new.existing_database
  let(:sequel_customer_gateway) { described_class.new(database: database) }

  it 'can get a customer' do
    customer_builder = Builder::Customer.new

    customer_builder.shipping_customer_name = 'Bob'
    customer_builder.shipping_address_line1 = '1 Fake Street'
    customer_builder.shipping_address_line2 = 'Fake Flat'
    customer_builder.shipping_city = 'Faketon'
    customer_builder.shipping_county = 'Fakeshire'
    customer_builder.shipping_postcode = 'FK1 1SW'
    customer_builder.shipping_phone_number = '018283818283'
    customer_builder.shipping_email_address = 'fake@gmail.com'
    customer_builder.billing_customer_name = 'Bob'
    customer_builder.billing_address_line1 = '12 Fakeish'
    customer_builder.billing_address_line2 = 'Fake block'
    customer_builder.billing_city = 'Fakeville'
    customer_builder.billing_county = 'Fakeishshire'
    customer_builder.billing_postcode = 'FK2 1EE'
    customer_builder.billing_phone_number = '01982371'
    customer_builder.billing_email_address = 'fake2@gmail.com'
    customer = customer_builder.build
    sequel_customer_gateway.save(customer)

    sequel_customer_gateway.all.last.tap do |customer|
      expect(customer.shipping_customer_name).to eq('Bob')
      expect(customer.shipping_address_line1).to eq('1 Fake Street')
      expect(customer.shipping_address_line2).to eq('Fake Flat')
      expect(customer.shipping_city).to eq('Faketon')
      expect(customer.shipping_county).to eq('Fakeshire')
      expect(customer.shipping_postcode).to eq('FK1 1SW')
      expect(customer.shipping_phone_number).to eq('018283818283')
      expect(customer.shipping_email_address).to eq('fake@gmail.com')
      expect(customer.billing_customer_name).to eq('Bob')
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
