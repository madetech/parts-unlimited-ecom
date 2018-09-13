# frozen_string_literal: true

require 'bigdecimal'

class CalculateTotalCost
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute
    @items = @items_gateway.all
    format('%.2f', order_total)
  end

  private

  def order_total
    return '0.00' if @items.empty?
    @items.map(&:total).sum
  end
end
