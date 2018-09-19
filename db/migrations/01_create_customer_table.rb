Sequel.migration do
  change do
    create_table :customer do
      primary_key :id
      String :shipping_customer_name, null: false
      String :shipping_address_line1, null: false
      String :shipping_address_line2
      String :shipping_city, null: false
      String :shipping_county, null: false
      String :shipping_postcode, null: false
      String :shipping_phone_number, null: false
      String :shipping_email_address, null: false
      String :billing_customer_name, null: false
      String :billing_address_line1, null: false
      String :billing_address_line2
      String :billing_city, null: false
      String :billing_county, null: false
      String :billing_postcode, null: false
      String :billing_phone_number, null: false
      String :billing_email_address, null: false
    end
  end
end
