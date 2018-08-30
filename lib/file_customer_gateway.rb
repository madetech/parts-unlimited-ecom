# frozen_string_literal: true
require 'json'

class FileCustomerGateway
  def all
    return [] unless File.exist?("#{__dir__}/../tmp/file.json")
    File.open("#{__dir__}/../tmp/file.json", 'r') do |file|
      customer_details = JSON.parse(file.read, symbolize_names: true)
      customer = Customer.new
      customer.customer_name = customer_details[:customer_name]
      customer.shipping_address_line1 = customer_details[:shipping_address_line1]
      customer.shipping_address_line2 = customer_details[:shipping_address_line2]
      customer.shipping_city = customer_details[:shipping_city]
      customer.shipping_county = customer_details[:shipping_county]
      customer.shipping_postcode = customer_details[:shipping_postcode]
      customer.shipping_phone_number = customer_details[:shipping_phone_number]
      customer.shipping_email_address = customer_details[:shipping_email_address]
      customer.billing_address_line1 = customer_details[:billing_address_line1]
      customer.billing_address_line2 = customer_details[:billing_address_line2]
      customer.billing_city = customer_details[:billing_city]
      customer.billing_county = customer_details[:billing_county]
      customer.billing_postcode = customer_details[:billing_postcode]
      customer.billing_phone_number = customer_details[:billing_phone_number]
      customer.billing_email_address = customer_details[:billing_email_address]
      [customer]
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

    File.open("#{__dir__}/../tmp/file.json", 'w') do |file|
      file.write(serialised_customer.to_json)
    end
  end

  def delete_all
    File.unlink("#{__dir__}/../tmp/file.json") if File.exist?("#{__dir__}/../tmp/file.json")
  end
end
