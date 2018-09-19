class SaveOrderDetails
  def initialize(order_gateway:)
    @order_gateway = order_gateway
  end

  def execute(order_details:)
    @order_details = order_details
    errors = validation

    return { successful: false, errors: errors } unless errors.empty?

    order_builder = Builder::Order.new

    order_builder.order_details = @order_details
    @order_gateway.save(order_builder.build)

    { successful: true, errors: [] }
  end

  def validation
    errors = missing_fields
    errors.push(:invalid_shipping_total) unless shipping_total_valid?
    errors
  end

  def missing_fields
    errors = []
    @order_details.each_key do |key|
      errors.push(:"missing_#{key}") if @order_details[key].empty?
    end
    errors
  end

  def shipping_total_valid?
    @order_details[:shipping_total].match(PRICE_REGEX)
  end

  PRICE_REGEX = /^[0-9]+(\.[0-9]+)?$/
end
