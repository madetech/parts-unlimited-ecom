# frozen_string_literal: true

class SaveCustomerDetails
  def initialize(customer_gateway:)
    @customer_gateway = customer_gateway
  end

  def execute(customer_details:)
    @customer_details = customer_details
    remove_whitespace
    
    errors = validate_details

    return { successful: false, errors: errors } unless errors.empty?

    customer_builder = Builder::Customer.new
    customer_builder.customer_details = @customer_details

    @customer_gateway.save(customer_builder.build)

    { successful: true, errors: [] }
  end

  private

  def remove_whitespace
    @customer_details.each_key do |key| 
      @customer_details[key] = @customer_details[key].strip
    end
  end

  def validate_details
    errors = check_for_missing_fields
    errors.push(check_phone_numbers)
    errors.push(check_postcodes)
    errors.push(check_emails)
    errors.flatten!
  end

  def check_for_missing_fields
    errors = []
    optional_details = %i[shipping_address_line2 billing_address_line2]
    @customer_details.each_key do |key|
      next if optional_details.include?(key)
      errors.push :"missing_#{key}" if @customer_details[key].empty?
    end
    errors
  end

  def check_phone_numbers
    errors = []
    errors.push(:invalid_shipping_phone_number) unless shipping_phone_number_valid?
    errors.push(:invalid_billing_phone_number) unless billing_phone_number_valid?
    errors
  end

  def shipping_phone_number_valid?
    phone_number_valid?(@customer_details[:shipping_phone_number])
  end

  def billing_phone_number_valid?
    phone_number_valid?(@customer_details[:billing_phone_number])
  end

  def phone_number_valid?(phone_number)
    phone_number.match(PHONE_NUMBER_REGEX)
  end

  def check_postcodes
    errors = []
    errors.push(:invalid_shipping_postcode) unless shipping_postcode_valid?
    errors.push(:invalid_billing_postcode) unless billing_postcode_valid?
    errors
  end

  def shipping_postcode_valid?
    postcode_valid?(@customer_details[:shipping_postcode])
  end

  def billing_postcode_valid?
    postcode_valid?(@customer_details[:billing_postcode])
  end

  def postcode_valid?(postcode)
    postcode.match(POSTCODE_REGEX)
  end

  def check_emails
    errors = []
    errors.push(:invalid_shipping_email_address) unless shipping_email_valid?
    errors.push(:invalid_billing_email_address) unless billing_email_valid?
    errors
  end

  def shipping_email_valid?
    email_valid?(@customer_details[:shipping_email_address])
  end

  def billing_email_valid?
    email_valid?(@customer_details[:billing_email_address])
  end

  def email_valid?(email)
    email.match(EMAIL_REGEX)
  end

  PHONE_NUMBER_REGEX = /^\A[+]?\d{11,12}\z$/
  POSTCODE_REGEX = /^[a-zA-Z]{1,2}([0-9]{1,2}|[0-9][a-zA-Z])\s*[0-9][a-zA-Z]{2}$/
  EMAIL_REGEX = /^[^@\W]+?@\w+?\..+?$/
end
