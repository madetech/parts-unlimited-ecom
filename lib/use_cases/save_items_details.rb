# frozen_string_literal: true

class SaveItemsDetails
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(items_details:)
    @items_details = items_details

    errors = []
    errors.push(missing?)
    errors = errors.flatten(1)

    return { successful: false, errors: errors } unless errors.empty?

    @items_gateway.save(items_details)

    return { successful: true, errors: [] }

  end

  private

  def missing?
    errors = []
    @items_details.each_with_index do |row, index|
      row.each_key do |col|
        errors.push([:"missing_#{col}", index]) if @items_details[index][col] == '' || @items_details[index][col] == 0
      end
    end
    errors
  end
end
