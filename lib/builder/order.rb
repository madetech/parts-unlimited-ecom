module Builder
  class Order
    attr_accessor :order_details

    def build
      order = ::Order.new
      order.shipping_total = order_details[:shipping_total]
      order
    end
  end
end
