require 'test_helper'

class StatusMailerTest < ActionMailer::TestCase
    test "received_application" do
        email = StatusMailer.received_application('Johndoe')

        #Send email and test that it got queued
        assert_emails 1 do
            email.deliver_now
        end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['info@bananaapp.org'], email.from
    assert_equal ['donor@donor.com'], email.to
    assert_equal 'We have received your application.', email.subject
    assert_equal read_fixture('received_application').join, email.body.to_s
  end
end
    