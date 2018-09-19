Sequel.migration do
  change do
    create_table :item do
      primary_key :id
      String :product_code, null: false
      String :name, null: false
      String :price, null: false
      String :quantity, null: false
    end
  end
end