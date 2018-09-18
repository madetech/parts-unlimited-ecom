class CalculateVAT
  def initialize(items_gateway:)
    @items_gateway = items_gateway
  end

  def execute
    @items = @items_gateway.all
    format('%.2f', vat_total)
  end

  private

  def vat_total
    return '0.00' if @items.empty?
    total = @items.map(&:total).sum
    vat = 0.2 * total
  end 

end
