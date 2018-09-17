# frozen_string_literal: true

class Customer
  extend Forwardable
  def_delegator :@shipping_address, :customer_name, :shipping_customer_name
  def_delegator :@shipping_address, :address_line1, :shipping_address_line1
  def_delegator :@shipping_address, :address_line2, :shipping_address_line2
  def_delegator :@shipping_address, :city, :shipping_city
  def_delegator :@shipping_address, :county, :shipping_county
  def_delegator :@shipping_address, :postcode, :shipping_postcode
  def_delegator :@shipping_address, :phone_number, :shipping_phone_number
  def_delegator :@shipping_address, :email_address, :shipping_email_address
  def_delegator :@billing_address, :customer_name, :billing_customer_name
  def_delegator :@billing_address, :address_line1, :billing_address_line1
  def_delegator :@billing_address, :address_line2, :billing_address_line2
  def_delegator :@billing_address, :city, :billing_city
  def_delegator :@billing_address, :county, :billing_county
  def_delegator :@billing_address, :postcode, :billing_postcode
  def_delegator :@billing_address, :phone_number, :billing_phone_number
  def_delegator :@billing_address, :email_address, :billing_email_address

  attr_accessor :shipping_address,
                :billing_address
end
