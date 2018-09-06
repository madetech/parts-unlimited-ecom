# frozen_string_literal: true

class SaveItemsDetails
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute(items_details:)
    @items_details = items_details

    errors = validation

    return { successful: false, errors: errors } unless errors.empty?

    @items_gateway.save(items_details)

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
    @items_details.each_with_index do |row, index|
      row.each_key do |col|
        errors.push([:"missing_#{col}", index]) if @items_details[index][col].empty?
      end
    end
    errors
  end


end
