# frozen_string_literal: true

require 'json'

class SequelItemsGateway
  def initialize(database:)
    @database = database
  end

  def all
    items = @database[:item].all
    return [] if items.empty?

    items.map do |item_details|
      item_builder = Builder::Item.new
      item_builder.from(
        id: item_details[:id],
        product_code: item_details[:product_code],
        name: item_details[:name],
        price: item_details[:price],
        quantity: item_details[:quantity]
      )
      item_builder.build
    end
  end

  def save(item)
    @database[:item].insert({
      product_code: item.product_code,
      name: item.name,
      price: item.price,
      quantity: item.quantity
    })
  end

  def delete_all
    @database[:item].delete
  end

  def delete_item(id)
    @database[:item].where(id: id).delete
  end
end
