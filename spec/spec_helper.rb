# frozen_string_literal: true

require 'builder/customer'
require 'builder/items'
require 'builder/order'
require 'domain/address'
require 'domain/customer'
require 'domain/items'
require 'domain/order'
require 'use_cases/save_customer_details'
require 'use_cases/view_summary'
require 'use_cases/save_items_details'
require 'use_cases/save_order_details'
require 'use_cases/calculate_total_cost'
require 'use_cases/calculate_vat'
require 'use_cases/delete_item'
require 'use_cases/duplicate_address'
require 'file_customer_gateway'
require 'file_items_gateway'
require 'file_order_gateway'
require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'index'
require 'database_admin/postgres'
require_relative '../db/migrator'

RSpec.configure do |config|
  database = DatabaseAdministrator::Postgres.new.fresh_database
  
  config.before(:all) { @database = database }

  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
