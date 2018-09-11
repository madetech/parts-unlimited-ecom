# frozen_string_literal: true

require 'json'

class FileItemsGateway
  FILE_PATH = "#{__dir__}/../tmp/items.json"

  def all
    return [] unless File.exist?(FILE_PATH)
    items = File.open(FILE_PATH, 'r') do |file|
      JSON.parse(file.read, symbolize_names: true)
    end

    items.map! do |item_details|
      item_builder = Builder::Item.new
      item_builder.from(
        id: item_details[:id],
        name: item_details[:name],
        price: item_details[:price],
        quantity: item_details[:quantity]
      )
      item_builder.build
    end
    items
  end

  def save(items)
    items.map! do |item|
      {
        id: item.id,
        name: item.name,
        price: item.price,
        quantity: item.quantity
      }
    end
    File.open(FILE_PATH, 'w') do |file|
      file.write(items.to_json)
    end
  end

  def delete_all
    File.unlink(FILE_PATH) if File.exist?(FILE_PATH)
  end

  def delete_row(index)
    items = all
    items.delete(items[index])
    save(items)
  end 
end
