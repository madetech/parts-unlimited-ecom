# frozen_string_literal: true

class SaveItemsDetails
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(items:)
    @items = items

    errors = validation

    return { successful: false, errors: errors } unless errors.empty?

    item_builder = ItemBuilder::Item.new
    item_builder.items = @items

    @items_gateway.save(item_builder.build)

    { successful: true, errors: [] }
  end

  private

  def validation
    errors = []
    errors.push(missing_fields)
    errors = errors.flatten(1)
    errors
  end

  def missing_fields
    errors = []
    @items.each_with_index do |row, index|
      row.each_key do |column|
        errors.push([:"missing_#{column}", index]) if @items[index][column].empty?
      end
    end
    errors
  end
end
