# frozen_string_literal: true

class DeleteItem
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(index:)
    @items_gateway.delete_item_at(index)
    {}
  end
end
