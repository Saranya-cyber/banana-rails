class StatusMailer < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  default from: 'info@bananaapp.org'
    def received_application(user)
        @user = user
        mail(to: @user.email, subject: 'Application Received')
    end
    
    def account_incomplete(user)
        @user = user
        mail(to: @user.email, subject: 'Account Incomplete')
    end

    def account_suspended(user)
      @user = user
      mail(to: @user.email, subject: 'Account Suspended')
    end

    def client_approved(user)
      @user = user
      mail(to: @user.email, subject: 'Application Approved')
    end

    def donor_approved(user)
      @user = user
      mail(to: @user.email, subject: 'Application Approved')
    end

end