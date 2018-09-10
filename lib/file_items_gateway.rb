# frozen_string_literal: true

require 'json'

class FileItemsGateway
  FILE_PATH = "#{__dir__}/../tmp/items.json"

  def all
    return [] unless File.exist?(FILE_PATH)
    File.open(FILE_PATH, 'r') do |file|
      item_builder = ItemBuilder::Item.new
      item_builder.items = JSON.parse(file.read, symbolize_names: true)
      [item_builder.build]
    end
  end

  def save(item)
    item.map! do |part|
      {
        id: part.id,
        name: part.name,
        price: part.price,
        quantity: part.quantity
      }
    end
    File.open(FILE_PATH, 'w') do |file|
      file.write(item.to_json)
    end
  end

  def delete_all
    File.unlink(FILE_PATH) if File.exist?(FILE_PATH)
  end
end
