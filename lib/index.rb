# !/usr/bin/env ruby -I ../lib -I lib
# frozen_string_literal: true

require 'sinatra'
require 'sequel_customer_gateway'
require 'sequel_items_gateway'
require 'file_order_gateway'
require 'use_cases/delete_item'
require 'use_cases/calculate_total_cost'
require 'use_cases/calculate_vat'
require 'use_cases/save_customer_details'
require 'use_cases/save_items_details'
require 'use_cases/save_order_details'
require 'use_cases/view_summary'
require 'use_cases/duplicate_address'
require 'builder/customer'
require 'builder/items'
require 'builder/order'
require 'domain/address'
require 'domain/customer'
require 'domain/items'
require 'database_admin/postgres'
require_relative '../db/migrator'
require 'domain/order'

helpers do
  def first_error?(error)
    @errors[0] == error
  end

  def second_error?(error)
    @errors[1] == error
  end
end

before do
  @database = DatabaseAdministrator::Postgres.new.existing_database
  @customer_gateway = SequelCustomerGateway.new(database: @database)
  @items_gateway = SequelItemsGateway.new(database: @database)
  @order_gateway = FileOrderGateway.new
  @calculate_total_cost = CalculateTotalCost.new(items_gateway: @items_gateway)
  @save_customer_details = SaveCustomerDetails.new(customer_gateway: @customer_gateway)
  @calculate_vat = CalculateVAT.new(items_gateway: @items_gateway)
  @view_summary = ViewSummary.new(customer_gateway: @customer_gateway, items_gateway: @items_gateway, calculate_total_cost: @calculate_total_cost, calculate_vat: @calculate_vat, order_gateway: @order_gateway)
  @delete_item = DeleteItem.new(items_gateway: @items_gateway)
  @duplicate_address = DuplicateAddress.new(save_customer_details: @save_customer_details)
end

after do
  @database.disconnect
end

get '/' do
  @customer_gateway.delete_all
  @items_gateway.delete_all
  @order_gateway.delete_all
  redirect '/customer-details'
end

get '/customer-details' do
  summary = @view_summary.execute
  @customer_details = summary[:customer] || {}
  @errors = []
  erb :customer_details
end

post '/customer-details' do
  shipping_customer_name = params.fetch(:shipping_customer_name)
  shipping_address_line1 = params.fetch(:shipping_address_line1)
  shipping_address_line2 = params.fetch(:shipping_address_line2)
  shipping_city = params.fetch(:shipping_city)
  shipping_county = params.fetch(:shipping_county)
  shipping_postcode = params.fetch(:shipping_postcode)
  shipping_phone_number = params.fetch(:shipping_phone_number)
  shipping_email_address = params.fetch(:shipping_email_address)
  billing_customer_name = params.fetch(:billing_customer_name)
  billing_address_line1 = params.fetch(:billing_address_line1)
  billing_address_line2 = params.fetch(:billing_address_line2)
  billing_city = params.fetch(:billing_city)
  billing_county = params.fetch(:billing_county)
  billing_postcode = params.fetch(:billing_postcode)
  billing_phone_number = params.fetch(:billing_phone_number)
  billing_email_address = params.fetch(:billing_email_address)
  use_same_address = params[:same_address]
  @customer_details = {
    shipping_customer_name: shipping_customer_name,
    shipping_address_line1: shipping_address_line1,
    shipping_address_line2: shipping_address_line2,
    shipping_city: shipping_city,
    shipping_county: shipping_county,
    shipping_postcode: shipping_postcode,
    shipping_phone_number: shipping_phone_number,
    shipping_email_address: shipping_email_address,
    billing_customer_name: billing_customer_name,
    billing_address_line1: billing_address_line1,
    billing_address_line2: billing_address_line2,
    billing_city: billing_city,
    billing_county: billing_county,
    billing_postcode: billing_postcode,
    billing_phone_number: billing_phone_number,
    billing_email_address: billing_email_address
  }
  response = @duplicate_address.execute(customer_details: @customer_details) if use_same_address
  response = @save_customer_details.execute(customer_details: @customer_details) unless use_same_address
  @errors = response[:errors]
  return redirect '/items-details' if response[:successful]

  erb :customer_details
end

get '/items-details' do
  summary = @view_summary.execute
  @net_total = summary[:net_total]
  @vat = summary[:vat_total]
  @items = summary[:items]
  @order = summary[:order]
  @errors = []
  @order_errors = []
  erb :items_details
end

post '/items-details' do
  price = params.fetch(:price)
  product_code = params.fetch(:product_code)
  name = params.fetch(:name)
  quantity = params.fetch(:quantity)

  @item_row = { product_code: product_code, name: name, price: price, quantity: quantity }

  save_items_details = SaveItemsDetails.new(items_gateway: @items_gateway)
  response = save_items_details.execute(item_details: @item_row)
  summary = @view_summary.execute
  @net_total = summary[:net_total]
  @vat = summary[:vat_total]
  @items = summary[:items]
  @order = summary[:order]
  @errors = response[:errors]
  @order_errors = []

  redirect '/items-details' if response[:successful]
  erb :items_details
end

post '/item-delete/:id' do
  id = params[:id]
  @delete_item.execute(id: id.to_i)
  redirect '/items-details'
end

post '/shipping-total' do
  shipping_total = params[:shipping_total]
  @order_details = { shipping_total: shipping_total }
  save_order_details = SaveOrderDetails.new(order_gateway: @order_gateway)
  response = save_order_details.execute(order_details: @order_details)
  summary = @view_summary.execute
  @net_total = summary[:net_total]
  @vat = summary[:vat_total]
  @items = summary[:items]
  @errors = []
  @order_errors = response[:errors]
  if summary[:items].empty?
    @errors.push(:no_items)
    return erb :items_details
  end
  redirect '/order-summary' if response[:successful]
  erb :items_details
end

get '/order-summary' do
  summary = @view_summary.execute
  @customer = summary[:customer]
  @items = summary[:items]
  @net_total = summary[:net_total]
  @vat = summary[:vat_total]
  @order = summary[:order]
  erb :summary
end
