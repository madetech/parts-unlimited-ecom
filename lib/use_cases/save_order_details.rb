class SaveOrderDetails
  def initialize(order_gateway:)
    @order_gateway = order_gateway
  end

  def execute(order_details:)
    @order_details = order_details

    order_builder = Builder::Order.new

    order_builder.order_details = @order_details
    @order_gateway.save(order_builder.build)
  end
end
