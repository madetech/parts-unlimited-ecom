class Items
  attr_accessor :part_id,
                :part_name,
                :part_price,
                :part_quantity,
                :part_total

  def item_total
    part_price * part_quantity
  end 
   
end
