# frozen_string_literal: true

module ItemBuilder
  class Item
    attr_accessor :items,
                  :id,
                  :name,
                  :price,
                  :quantity

    def build
      copy_from_individual_fields unless items_exist?
      items.map! do |part|
        item = ::Item.new
        item.id = part[:id]
        item.name = part[:name]
        item.price = part[:price]
        item.quantity = part[:quantity]
        item
      end
      items
    end

    private

    def items_exist?
      !items.nil?
    end

    def copy_from_individual_fields
      @items = {
        id: id,
        name: name,
        price: price,
        quantity: quantity
      }
    end
  end
end
