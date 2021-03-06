require 'rails_helper'

RSpec.describe 'User can make a reservation', type: :feature do
  scenario 'they click checkout in the cart and the reservation is made' do
    user = create(:user)
    business = create(:business, user: user)
    location = create(:location)
    create(:property, business: business, location: location)
    property = location.properties.first

    visit login_path

    fill_in 'Username', with: user.username
    fill_in 'Password', with: user.password

    within('.login-form') do
      click_on "Login"
    end

    visit property_path(property, business_name: property.business.slug)

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "08/30/2016"
    fill_in 'booking[end_date]', with: "09/05/2016"

    click_on "Book Me"
    click_button 'Complete My Booking'

    order = Order.last

    expect(current_path).to eq order_path(order)

    within('.flash-success') do
      expect(page).to have_content "Your order has been placed!"
    end

    expect(page).to have_content "Order ##{order.id} Details"
  end
end
