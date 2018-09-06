# frozen_string_literal: true
#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'sinatra'
require './lib/file_customer_gateway'
require './lib/use_cases/save_customer_details'
require './lib/builder/customer'
require './lib/domain/address'
require './lib/domain/customer'


get '/' do 
  redirect '/customer-details'
end

get '/customer-details' do
  @customer_details = {}
  @errors = []
  erb :customer_details
end

post '/customer-details' do
  customer_name = params.fetch(:customer_name)
  shipping_address_line1 = params.fetch(:shipping_address_line1)
  shipping_address_line2 = params.fetch(:shipping_address_line2)
  shipping_city = params.fetch(:shipping_city)
  shipping_county = params.fetch(:shipping_county)
  shipping_postcode = params.fetch(:shipping_postcode)
  shipping_phone_number = params.fetch(:shipping_phone_number)
  shipping_email_address = params.fetch(:shipping_email_address)
  billing_address_line1 = params.fetch(:billing_address_line1)
  billing_address_line2 = params.fetch(:billing_address_line2)
  billing_city = params.fetch(:billing_city)
  billing_county = params.fetch(:billing_county)
  billing_postcode = params.fetch(:billing_postcode)
  billing_phone_number = params.fetch(:billing_phone_number)
  billing_email_address = params.fetch(:billing_email_address)
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
  customer_gateway = FileCustomerGateway.new
  save_customer_details = SaveCustomerDetails.new(customer_gateway: customer_gateway)
  response = save_customer_details.execute(customer_details: @customer_details)
  @errors = response[:errors]

  return redirect '/add-items' if response[:successful]
  erb :customer_details
end

