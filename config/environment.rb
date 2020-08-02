# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#Sendgrid 
# ActionMailer::Base.smtp_settings = {
#  :user_name => '',
#  :password => '',
#  :domain => '',
#  :address => '',
#  :port => '',
#  :authentication => "plain",
#  :enable_starttls_auto => true,
#  :tls => true
# }