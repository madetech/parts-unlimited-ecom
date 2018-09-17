# frozen_string_literal: true

Capybara.app = Sinatra::Application

describe 'items details', type: :feature do
  def visit_items_details_page_in_form
    visit '/items-details'
    within('form#new-row') do
      yield
    end
    click_button('Add')
  end

  it 'accepts a valid row' do
    visit_items_details_page_in_form do
      fill_in('id', with: '1234')
      fill_in('name', with: 'Abacus')
      fill_in('price', with: '12.50')
      fill_in('quantity', with: '7')
    end
    expect(page).to have_content('1234')
    expect(page).to have_content('Abacus')
    expect(page).to have_content('12.50')
    expect(page).to have_content('7')
  end

  it 'blocks an empty id' do
    visit_items_details_page_in_form do
      fill_in('name', with: 'Part')
      fill_in('price', with: '7.20')
      fill_in('quantity', with: '9')
    end
    expect(page).not_to have_content('Part')
    expect(page).not_to have_content('7.20')
    expect(page).not_to have_content('9')
  end

  it 'blocks an empty name' do
    visit_items_details_page_in_form do
      fill_in('id', with: '567')
      fill_in('price', with: '7.20')
      fill_in('quantity', with: '9')
    end
    expect(page).not_to have_content('567')
    expect(page).not_to have_content('7.20')
    expect(page).not_to have_content('9')
  end

  it 'blocks an empty price' do
    visit_items_details_page_in_form do
      fill_in('id', with: '567')
      fill_in('name', with: 'Part')
      fill_in('quantity', with: '9')
    end
    expect(page).not_to have_content('567')
    expect(page).not_to have_content('Part')
    expect(page).not_to have_content('9')
  end

  it 'blocks an empty quantity' do
    visit_items_details_page_in_form do
      fill_in('id', with: '567')
      fill_in('name', with: 'Part')
      fill_in('price', with: '7.20')
    end
    expect(page).not_to have_content('567')
    expect(page).not_to have_content('Part')
    expect(page).not_to have_content('7.20')
  end

  it 'blocks an invalid price' do
    visit_items_details_page_in_form do
      fill_in('id', with: '567')
      fill_in('name', with: 'Part')
      fill_in('price', with: 'twenty')
      fill_in('quantity', with: '9')
    end
    expect(page).not_to have_content('567')
    expect(page).not_to have_content('Part')
    expect(page).not_to have_content('twenty')
    expect(page).not_to have_content('9')
  end

  it 'blocks an invalid quantity' do
    visit_items_details_page_in_form do
      fill_in('id', with: '567')
      fill_in('name', with: 'Part')
      fill_in('price', with: '7.20')
      fill_in('quantity', with: 'nine')
    end
    expect(page).not_to have_content('567')
    expect(page).not_to have_content('Part')
    expect(page).not_to have_content('7.20')
    expect(page).not_to have_content('nine')
  end
end
