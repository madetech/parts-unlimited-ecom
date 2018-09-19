# frozen_string_literal: true

class FileCustomerGateway

  def initialize(database:)
    @database = database
  end

  def all
    customers = @database[:customer].all
    return [] if customers.empty?
    customers.map do |customer|
      customer_builder = Builder::Customer.new
      customer_builder.customer_details = customer
      customer_builder.build
    end
  end

  def save(customer)
    serialised_customer = {
      shipping_customer_name: customer.shipping_customer_name,
      shipping_address_line1: customer.shipping_address_line1,
      shipping_address_line2: customer.shipping_address_line2,
      shipping_city: customer.shipping_city,
      shipping_county: customer.shipping_county,
      shipping_postcode: customer.shipping_postcode,
      shipping_phone_number: customer.shipping_phone_number,
      shipping_email_address: customer.shipping_email_address,
      billing_customer_name: customer.billing_customer_name,
      billing_address_line1: customer.billing_address_line1,
      billing_address_line2: customer.billing_address_line2,
      billing_city: customer.billing_city,
      billing_county: customer.billing_county,
      billing_postcode: customer.billing_postcode,
      billing_phone_number: customer.billing_phone_number,
      billing_email_address: customer.billing_email_address
    }

    @database[:customer].insert(serialised_customer)
  end
end
