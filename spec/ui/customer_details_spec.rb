# frozen_string_literal: true

Capybara.app = Sinatra::Application

describe 'customer details', type: :feature do
  def visit_customer_details_page_in_form
    visit '/customer-details'
    within('form') do
      yield
    end
    click_button('Next')
  end

  it 'autofocuses on an incorrect field' do
    FileCustomerGateway.new.delete_all
    visit_customer_details_page_in_form do
      fill_in('shipping_address_line1', with: '1 Fake Street')
      fill_in('shipping_address_line2', with: 'Fake Flat')
      fill_in('shipping_city', with: 'Faketon')
      fill_in('shipping_county', with: 'Fakeshire')
      fill_in('shipping_postcode', with: 'FK1 1SW')
      fill_in('shipping_phone_number', with: '01828381828')
      fill_in('shipping_email_address', with: 'fake@gmail.com')
      fill_in('billing_customer_name', with: 'Bob')
      fill_in('billing_address_line1', with: '12 Fakeish')
      fill_in('billing_address_line2', with: 'Fake block')
      fill_in('billing_city', with: 'Fakeville')
      fill_in('billing_county', with: 'Fakeishshire')
      fill_in('billing_postcode', with: 'FK2 1EE')
      fill_in('billing_phone_number', with: '01982371234')
      fill_in('billing_email_address', with: 'fake2@gmail.com')
    end
    expect(page).to have_css('input[autofocus]')
  end

  it 'accepts a customer name' do
    visit_customer_details_page_in_form { fill_in('shipping_customer_name', with: 'Larry') }
    expect(page).to have_no_content('Please enter a shipping name')
  end

  it 'does not accept an invalid phone number' do
    visit_customer_details_page_in_form { fill_in('shipping_phone_number', with: '0123453') }
    expect(page).to have_content('This phone number is invalid')
  end

  it 'does not accept an invalid postcode' do
    visit_customer_details_page_in_form { fill_in('shipping_postcode', with: '01G GH2') }
    expect(page).to have_content('This postcode is invalid')
  end

  it 'does not accept an invalid email address' do
    visit_customer_details_page_in_form { fill_in('billing_email_address', with: 'emma£madetea,co') }
    expect(page).to have_content('This email is invalid')
  end

  it 'goes to the add items page' do
    visit_customer_details_page_in_form do
      fill_in('shipping_customer_name', with: 'Bob')
      fill_in('shipping_address_line1', with: '1 Fake Street')
      fill_in('shipping_address_line2', with: 'Fake Flat')
      fill_in('shipping_city', with: 'Faketon')
      fill_in('shipping_county', with: 'Fakeshire')
      fill_in('shipping_postcode', with: 'FK1 1SW')
      fill_in('shipping_phone_number', with: '01828381828')
      fill_in('shipping_email_address', with: 'fake@gmail.com')
      fill_in('billing_customer_name', with: 'Bob')
      fill_in('billing_address_line1', with: '12 Fakeish')
      fill_in('billing_address_line2', with: 'Fake block')
      fill_in('billing_city', with: 'Fakeville')
      fill_in('billing_county', with: 'Fakeishshire')
      fill_in('billing_postcode', with: 'FK2 1EE')
      fill_in('billing_phone_number', with: '01982371234')
      fill_in('billing_email_address', with: 'fake2@gmail.com')
    end
    expect(current_path).to eq('/items-details')
  end

  it 'keeps content on the page if there is an invalid entry' do
    visit_customer_details_page_in_form do
      fill_in('shipping_customer_name', with: 'Bob')
      fill_in('shipping_address_line1', with: '1 Fake Street')
      fill_in('shipping_address_line2', with: 'Fake Flat')
      fill_in('shipping_city', with: 'Faketon')
      fill_in('shipping_county', with: 'Fakeshire')
      fill_in('shipping_postcode', with: 'FK1 1SW')
      fill_in('shipping_phone_number', with: '01828381')
      fill_in('shipping_email_address', with: 'fake@gmail.com')
      fill_in('billing_customer_name', with: 'Bob')
      fill_in('billing_address_line1', with: '12 Fakeish')
      fill_in('billing_address_line2', with: 'Fake block')
      fill_in('billing_city', with: 'Fakeville')
      fill_in('billing_county', with: 'Fakeishshire')
      fill_in('billing_postcode', with: 'FK2 1EE')
      fill_in('billing_phone_number', with: '01982371234')
      fill_in('billing_email_address', with: 'fake2@gmail.com')
    end
    expect(find_field('shipping_customer_name').value).to eq('Bob')
    expect(find_field('shipping_address_line1').value).to eq('1 Fake Street')
    expect(find_field('shipping_address_line2').value).to eq('Fake Flat')
    expect(find_field('shipping_city').value).to eq('Faketon')
    expect(find_field('shipping_county').value).to eq('Fakeshire')
    expect(find_field('shipping_postcode').value).to eq('FK1 1SW')
    expect(find_field('shipping_phone_number').value).to eq('01828381')
    expect(find_field('shipping_email_address').value).to eq('fake@gmail.com')
    expect(find_field('billing_customer_name').value).to eq('Bob')
    expect(find_field('billing_address_line1').value).to eq('12 Fakeish')
    expect(find_field('billing_address_line2').value).to eq('Fake block')
    expect(find_field('billing_city').value).to eq('Fakeville')
    expect(find_field('billing_county').value).to eq('Fakeishshire')
    expect(find_field('billing_postcode').value).to eq('FK2 1EE')
    expect(find_field('billing_phone_number').value).to eq('01982371234')
    expect(find_field('billing_email_address').value).to eq('fake2@gmail.com')
    expect(current_path).to eq('/customer-details')
  end
end
