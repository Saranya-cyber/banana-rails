class AccountStatusHelper

    def self.account_status(userType, user, status, id)
        if status.empty?
           failure_message = { error: "account_status is  empty" }
           return {message: failure_message, status: 400}
        end

        if !(status == AccountStatus::APPROVED || status == AccountStatus::ACTIVE || status == AccountStatus::INCOMPLETE ||status == AccountStatus::INACTIVE || status == AccountStatus::SUSPENDED || status == AccountStatus::CLOSED)
            failure_message = { message: "Invalid status" }
            return {message: failure_message, status: 400}
        end

        if status == user.account_status
            success_message = { message: "#{userType} id: #{id} status was not updated as the user is already #{status}" }
            return {message: success_message, status: 204}
        end

        success_message = { message: "#{userType} id: #{id} status changed to #{status}. Was: #{user.account_status}" }
        failure_message = { error: "#{userType} id: #{id} status not changed to #{status}.  Remained: #{user.account_status}" }
        success = user.update_attribute(:account_status, status)
        return success ?
            {message: success_message, status: 200} :
            {message: failure_message, status: 500}
    end
end

module AccountStatus
  PROCESSING = 'processing'
  APPROVED = 'approved'
  ACTIVE = 'active'
  INCOMPLETE = 'incomplete'
  INACTIVE = 'inactive'
  SUSPENDED = 'suspended'
  CLOSED = 'closed'
end
