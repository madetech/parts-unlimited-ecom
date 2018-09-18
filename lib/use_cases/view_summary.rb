# frozen_string_literal: true

class ViewSummary
  def initialize(customer_gateway:, items_gateway:, calculate_total_cost:, calculate_vat:, order_gateway:)
    @customer_gateway = customer_gateway
    @items_gateway = items_gateway
    @calculate_total_cost = calculate_total_cost
    @calculate_vat = calculate_vat
    @order_gateway = order_gateway
  end

  def execute
    { customer: customer, items: items, net_total: @calculate_total_cost.execute, vat_total: @calculate_vat.execute , order: order}
  end

  private

  def customer
    return nil if @customer_gateway.all.empty?
    customer = @customer_gateway.all.last
    { shipping_customer_name: customer.shipping_customer_name,
      shipping_address_line1: customer.shipping_address_line1,
      shipping_address_line2: customer.shipping_address_line2,
      shipping_city: customer.shipping_city,
      shipping_county: customer.shipping_county,
      shipping_postcode: customer.shipping_postcode,
      shipping_phone_number: customer.shipping_phone_number,
      shipping_email_address: customer.shipping_email_address,
      billing_customer_name: customer.billing_customer_name,
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
        product_code: item.product_code,
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        total: format('%.2f', item.total)
      }
    end
    items
  end

  def order
    order = @order_gateway.all.first
    {
      shipping_total: order.shipping_total
    }
  end
end
