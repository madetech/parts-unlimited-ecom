# frozen_string_literal: true

class SaveCustomerDetails
  def initialize(customer_gateway:)
    @customer_gateway = customer_gateway
  end

  def execute(customer_details:)
    customer_builder = Builder::Customer.new
    customer_builder.customer_details = customer_details
    
    @customer_gateway.save(customer_builder.build)
  end
end
