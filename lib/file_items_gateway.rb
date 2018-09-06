require 'json'

class FileItemsGateway
  FILE_PATH = "#{__dir__}/../tmp/items.json"

  def all
    return [] unless File.exist?(FILE_PATH)
    File.open(FILE_PATH, 'r') do |file|
      JSON.parse(file.read, symbolize_names: true)
    end
  end

  def save(items)
    File.open(FILE_PATH, 'w') do |file|
      file.write(items.to_json)
    end
  end

  def delete_all
    File.unlink(FILE_PATH) if File.exist?(FILE_PATH)
  end
end
