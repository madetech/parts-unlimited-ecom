# frozen_string_literal: true

class ViewSummary
  def initialize(customer_gateway:, items_gateway:, calculate_total_cost:)
    @customer_gateway = customer_gateway
    @items_gateway = items_gateway
    @calculate_total_cost = calculate_total_cost
  end

  def execute
    { customer: customer, items: items, net_total: @calculate_total_cost.execute }
  end

  private

  def customer
    customer = @customer_gateway.all.first
    { customer_name: customer.customer_name,
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
      billing_email_address: customer.billing_email_address }
  end

  def items
    items = @items_gateway.all
    items.map! do |item|
      {
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        total: '%.2f'%item.total
      }
    end
    items
  end
end
