class StatusMailer < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  default from: 'info@bananaapp.org'
  def send_status_email(user)
        @user = user
        mail(to: @user.email, subject: 'test status')
    end
    
    # def status_changed
    #     @user = params[:user]

    #     mail(to: @user.email, subject: 'Your account is #{@user.account_status}')
    # end
end