require 'test_helper'

class DonationsControllerTest < ActionDispatch::IntegrationTest
  test "we can create a donation" do
    post donations_create_url, params: {donation: {category: DonationCategory::PRODUCE, food_name: 'bananas!!!',
                                                   total_amount:'20 bunches', donor_id: 1, pickup_instructions: 'Front door',
                                                   status: DonationStatus::ACTIVE}}, headers: auth_header({donor_id: 1})
    assert_response :success
    assert_not_nil Donation.find_by_food_name 'bananas!!!'
  end

  test "failed validation causes 422 response" do
    food_name = 'carrots!!!'
    post donations_create_url, params: {donation: { food_name: food_name,
                                                   total_amount:'20 bunches', donor_id: 1, pickup_instructions: 'Front door',
                                                   status: DonationStatus::ACTIVE}}, headers: auth_header({donor_id: 1})
    assert_response 422
    assert_nil Donation.find_by_food_name food_name
  end
end
