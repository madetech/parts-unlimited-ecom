# frozen_string_literal: true

class SaveItemsDetails
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(item_details:)
    @item_details = item_details
    errors = validation

    return { successful: false, errors: errors } unless errors.empty?
    item_builder = Builder::Item.new
    item_builder.from(
      product_code: @item_details[:product_code],
      name: @item_details[:name],
      price: @item_details[:price],
      quantity: @item_details[:quantity]
    )

    @items_gateway.save(item_builder.build)

    { successful: true, errors: [] }
  end

  private

  def validation
    errors = missing_fields
    errors.push(:invalid_price) unless price_valid?
    errors.push(:invalid_quantity) unless quantity_valid?
    errors
  end

  def missing_fields
    errors = []
    @item_details.each_key do |key|
      errors.push(:"missing_#{key}") if @item_details[key].empty?
    end
    errors
  end

  def price_valid?
    @item_details[:price].match(PRICE_REGEX)
  end

  def quantity_valid?
    @item_details[:quantity].match(QUANTITY_REGEX)
  end

  PRICE_REGEX = /^[0-9]+(\.[0-9]+)?$/
  QUANTITY_REGEX = /^[0-9]+(\.[0-9]+)?$/
end
