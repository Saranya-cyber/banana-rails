class AccountStatusHelper
    def self.activate(userType, user, status, id)
        failure_message = { error: "#{userType} id: #{id} status not changed to active.  Remained: #{status}" }
        if status == AccountStatus::APPROVED
            success_message = { message: "#{userType} id: #{id} status changed to active. Was: #{status}" }
            user.update_attribute(:account_status, 'active')
            return {message: success_message, status: 200}
        elsif status == AccountStatus::ACTIVE
            success_message = { message: "#{userType} id: #{id} status was not updated as the user is already active" }
            return { message: success_message, status: 204 }
        else
            return { message: failure_message, status: 400 }
        end
    end

    def self.account_status(userType, user, status, id)
        if status == user.account_status
            success_message = { message: "#{userType} id: #{id} status was not updated as the user is already #{status}" }
            return {message: success_message, status: 204}
        end
        success_message = { message: "#{userType} id: #{id} status changed to #{status}. Was: #{user.account_status}" }
        failure_message = { error: "#{userType} id: #{id} status not changed to #{status}.  Remained: #{user.account_status}" }
        success = user.update_attribute(:account_status, status)
        return success ?
            {message: success_message, status: 200} :
            {message: failure_message, status: 400}
    end
end
module AccountStatus
  PROCESSING = 'processing'
  APPROVED = 'approved'
  ACTIVE = 'active'
end
