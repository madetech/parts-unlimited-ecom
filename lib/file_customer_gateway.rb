# frozen_string_literal: true

require 'json'

class FileCustomerGateway
  FILE_PATH = "#{__dir__}/../tmp/file.json"

  def all
    return [] unless File.exist?(FILE_PATH)
    File.open(FILE_PATH, 'r') do |file|
      customer_builder = Builder::Customer.new
      customer_builder.customer_details = JSON.parse(file.read, symbolize_names: true)
      [customer_builder.build]
    end
  end

  def save(customer)
    serialised_customer = {
      customer_name: customer.customer_name,
      shipping_address_line1: customer.shipping_address_line1,
      shipping_address_line2: customer.shipping_address_line2,
      shipping_city: customer.shipping_city,
      shipping_county: customer.shipping_county,
      shipping_postcode: customer.shipping_postcode,
      shipping_phone_number: customer.shipping_phone_number,
      shipping_email_address: customer.shipping_email_address,
      billing_address_line1: customer.billing_address_line1,
      billing_address_line2: customer.billing_address_line2,
      billing_city: customer.billing_city,
      billing_county: customer.billing_county,
      billing_postcode: customer.billing_postcode,
      billing_phone_number: customer.billing_phone_number,
      billing_email_address: customer.billing_email_address
    }

    File.open(FILE_PATH, 'w') do |file|
      file.write(serialised_customer.to_json)
    end
  end

  def delete_all
    File.unlink(FILE_PATH) if File.exist?(FILE_PATH)
  end
end
