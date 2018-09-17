# frozen_string_literal: true

class DuplicateAddress
  def initialize(save_customer_details:)
    @save_customer_details = save_customer_details
  end

  def execute(customer_details:)
    @customer_details = customer_details
    duplicate_shipping_address
    @save_customer_details.execute(customer_details: @customer_details)
  end

  private

  def duplicate_shipping_address
    @customer_details[:billing_customer_name] = @customer_details[:shipping_customer_name]
    @customer_details[:billing_address_line1] = @customer_details[:shipping_address_line1]
    @customer_details[:billing_address_line2] = @customer_details[:shipping_address_line2]
    @customer_details[:billing_city] = @customer_details[:shipping_city]
    @customer_details[:billing_county] = @customer_details[:shipping_county]
    @customer_details[:billing_postcode] = @customer_details[:shipping_postcode]
    @customer_details[:billing_email_address] = @customer_details[:shipping_email_address]
    @customer_details[:billing_phone_number] = @customer_details[:shipping_phone_number]
  end
end
