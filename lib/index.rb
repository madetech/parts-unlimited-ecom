# !/usr/bin/env ruby -I ../lib -I lib
# frozen_string_literal: true

require 'sinatra'
require './lib/file_customer_gateway'
require './lib/use_cases/save_customer_details'
require './lib/use_cases/save_items_details'
require './lib/use_cases/view_summary'
require './lib/builder/customer'
require './lib/domain/address'
require './lib/domain/customer'

class ItemsGateway
  def all
    [
      { part_id: 456, part_name: 'Drones', part_price: 144, part_quantity: 34 },
      { part_id: 454, part_name: 'Uranium', part_price: 130, part_quantity: 100 },
      { part_id: 767, part_name: 'ACHSDJVHJDWVVFWVYEUVFW', part_price: 10, part_quantity: 200000 },
      { part_id: 999, part_name: 'Screws', part_price: 0.9, part_quantity: 2000 },
      { part_id: 456, part_name: 'Drones', part_price: 144, part_quantity: 34 },
      { part_id: 454, part_name: 'Uranium', part_price: 130, part_quantity: 100 },
      { part_id: 767, part_name: 'ACHSDJVHJDWVVFWVYEUVFW', part_price: 10, part_quantity: 200000 },
      { part_id: 999, part_name: 'Screws', part_price: 0.9, part_quantity: 2000 },
      { part_id: 456, part_name: 'Drones', part_price: 144, part_quantity: 34 },
      { part_id: 454, part_name: 'Uranium', part_price: 130, part_quantity: 100 },
      { part_id: 767, part_name: 'ACHSDJVHJDWVVFWVYEUVFW', part_price: 10, part_quantity: 200000 },
      { part_id: 999, part_name: 'Screws', part_price: 0.9, part_quantity: 2000 },
      { part_id: 456, part_name: 'Drones', part_price: 144, part_quantity: 34 },
      { part_id: 454, part_name: 'Uranium', part_price: 130, part_quantity: 100 },
      { part_id: 767, part_name: 'ACHSDJVHJDWVVFWVYEUVFW', part_price: 10, part_quantity: 200000 },
      { part_id: 999, part_name: 'Screws', part_price: 0.9, part_quantity: 2000 },
      { part_id: 456, part_name: 'Drones', part_price: 144, part_quantity: 34 },
      { part_id: 454, part_name: 'Uranium', part_price: 130, part_quantity: 100 },
      { part_id: 767, part_name: 'ACHSDJVHJDWVVFWVYEUVFW', part_price: 10, part_quantity: 200000 },
      { part_id: 999, part_name: 'Screws', part_price: 0.9, part_quantity: 2000 }
    ]
  end
end

get '/' do
  redirect '/customer-details'
end

get '/customer-details' do
  @customer_details = {}
  @errors = []
  erb :customer_details
end

get '/items-details' do
  @items_details = []
  @errors = []
  erb :items_details
end

get '/order-summary' do
  file_items_gateway = ItemsGateway.new
  file_customer_gateway = FileCustomerGateway.new
  view_summary = ViewSummary.new(customer_gateway: file_customer_gateway, items_gateway: file_items_gateway)
  summary = view_summary.execute
  @customer = summary[:customer]
  @items = summary[:items]
  erb :summary
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

  return redirect '/items-details' if response[:successful]
  erb :customer_details
end
