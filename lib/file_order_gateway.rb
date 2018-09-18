class FileOrderGateway
  FILE_PATH = "#{__dir__}/../tmp/order.json"

  def all
    return [] unless File.exist?(FILE_PATH)
    File.open(FILE_PATH, 'r') do |file|
      order_builder = Builder::Order.new
      order_builder.order_details = JSON.parse(file.read, symbolize_names: true)
      [order_builder.build]
    end
  end

  def save(order)
    order = {
      shipping_total: order.shipping_total
    }
    File.open(FILE_PATH, 'w') do |file|
      file.write(order.to_json)
    end
  end

  def delete_all
    File.unlink(FILE_PATH) if File.exist?(FILE_PATH)
  end
end
