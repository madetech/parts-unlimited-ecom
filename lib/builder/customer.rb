module Builder
  class Customer
    attr_accessor :customer_details,
                  :customer_name,
                  :shipping_address_line1,
                  :shipping_address_line2,
                  :shipping_city,
                  :shipping_county,
                  :shipping_postcode,
                  :shipping_phone_number,
                  :shipping_email_address,
                  :billing_address_line1,
                  :billing_address_line2,
                  :billing_city,
                  :billing_county,
                  :billing_postcode,
                  :billing_phone_number,
                  :billing_email_address

    def build
      copy_from_individual_fields unless customer_details_is_used?
      customer = ::Customer.new
      customer.customer_name = customer_details[:customer_name]
      customer.shipping_address = build_shipping_address
      customer.billing_address = build_billing_address
      customer
    end
    
    private
    
    def build_shipping_address
      shipping_address = ::Address.new
      shipping_address.address_line1 = customer_details[:shipping_address_line1]
      shipping_address.address_line2 = customer_details[:shipping_address_line2]
      shipping_address.city = customer_details[:shipping_city]
      shipping_address.county = customer_details[:shipping_county]
      shipping_address.postcode = customer_details[:shipping_postcode]
      shipping_address.phone_number = customer_details[:shipping_phone_number]
      shipping_address.email_address = customer_details[:shipping_email_address]
      shipping_address
    end
    
    def build_billing_address
      billing_address = ::Address.new
      billing_address.address_line1 = customer_details[:billing_address_line1]
      billing_address.address_line2 = customer_details[:billing_address_line2]
      billing_address.city = customer_details[:billing_city]
      billing_address.county = customer_details[:billing_county]
      billing_address.postcode = customer_details[:billing_postcode]
      billing_address.phone_number = customer_details[:billing_phone_number]
      billing_address.email_address = customer_details[:billing_email_address]
      billing_address
    end

    def customer_details_is_used?
      !customer_details.nil?
    end

    def copy_from_individual_fields
      @customer_details = {
        customer_name: customer_name,
        shipping_address_line1: shipping_address_line1,
        shipping_address_line2: shipping_address_line2,
        shipping_city: shipping_city,
        shipping_county: shipping_county,
        shipping_postcode: shipping_postcode,
        shipping_phone_number: shipping_phone_number,
        shipping_email_address: shipping_email_address,
        billing_address_line1: billing_address_line1,
        billing_address_line2: billing_address_line2,
        billing_city: billing_city,
        billing_county: billing_county,
        billing_postcode: billing_postcode,
        billing_phone_number: billing_phone_number,
        billing_email_address: billing_email_address
      }
    end
  end
end
