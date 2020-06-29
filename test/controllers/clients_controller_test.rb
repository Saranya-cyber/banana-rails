require 'test_helper'


class ClientsControllerTest < ActionDispatch::IntegrationTest

  test "we return 409 status code in the event the client email is already present in the db" do
    post clients_create_url, params: {client: { email: "client@client.com", password: "does not matter",
                                                   address_zip: 90210}}
    assert_response :conflict
  end

  test "we successfully register a new client" do
    post clients_create_url, params: {client: { email: "notindb@notindb.com", password: "password1!",
                                                address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :success
    just_added = Client.find_by_email("notindb@notindb.com")
    assert_not_nil just_added
  end

  test "we successfully register a new client and account status defaults to processing" do
    post clients_create_url, params: {client: { email: "acc_status_notindb@notindb.com", password: "password1!",
                                                address_zip: 90210, first_name: "Newname", last_name: "Client"}}
    assert_response :success
    just_added = Client.find_by_email("acc_status_notindb@notindb.com")
    assert_equal AccountStatus::PROCESSING, just_added.account_status, "account_status should have defaulted to #{AccountStatus::PROCESSING}"
  end

end
