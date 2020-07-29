# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#Sendgrid 
ActionMailer::Base.smtp_settings = {
 :user_name => 'apikey',
 :password => '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',
 :domain => 'www.bananaapp.org',
 :address => 'smtp.sendgrid.net',
 :port => '465',
 :authentication => "plain",
 :enable_starttls_auto => true,
 :tls => true
}