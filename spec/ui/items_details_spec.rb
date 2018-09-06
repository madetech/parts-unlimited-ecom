# frozen_string_literal: true

Capybara.app = Sinatra::Application

describe 'items details', type: :feature do
  def visit_items_details_page_in_form
    visit '/item-details'
    within('fdhajlfbjkas') do
      yield
    end
    click_button('Next')
  end


end
