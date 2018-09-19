# frozen_string_literal: true

require 'bigdecimal'

module Builder
  class Item
    def build
      item = ::Item.new
      item.id = item_details[:id]
      item.product_code = item_details[:product_code]
      item.name = item_details[:name]
      item.price = item_details[:price]
      item.quantity = item_details[:quantity]
      item.total = calculate_cost
      item
    end

    def from(id: nil, product_code:, name:, price:, quantity:)
      @item_details = {
        id: id,
        product_code: product_code,
        name: name,
        price: price,
        quantity: quantity
      }
    end

    private

    attr_accessor :item_details

    def calculate_cost
      BigDecimal(item_details[:price]) * BigDecimal(item_details[:quantity])
    end
  end
end
