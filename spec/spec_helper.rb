# frozen_string_literal: true

require 'builder/customer'
require 'domain/address'
require 'domain/customer'
require 'use_cases/save_customer_details'
require 'use_cases/view_summary'
require 'use_cases/save_items_details'
require 'file_customer_gateway'
require 'file_items_gateway'
require 'rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'index'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
