# frozen_string_literal: true

class DeleteItem
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(id:)
    @items_gateway.delete_item(id)
    {}
  end
end
