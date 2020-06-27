class AccountStatusHelper
    def self.activate(userType, user, status, id)
        failure_message = { error: "#{userType} id: #{id} status not changed to active.  Remained: #{status}" }
        if status == 'approved'
            success_message = { message: "#{userType} id: #{id} status changed to active. Was: #{status}" }
            user.update_attribute(:account_status, 'active')
            return {message: success_message, status: 200}
        elsif status == 'active'
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
        case status
        when 'approved'
            success = user.update_attribute(:account_status, 'approved')
        when 'processing'
            success = user.update_attribute(:account_status, 'processing')
        when 'active'
            success = user.update_attribute(:account_status, 'active')
        when 'incomplete'
            success = user.update_attribute(:account_status, 'incomplete')
        when 'inactive'
        success = user.update_attribute(:account_status, 'inactive')
        when 'suspended'
            success = user.update_attribute(:account_status, 'suspended')
        when 'closed'
            success = user.update_attribute(:account_status, 'closed')
        end

        return success ?
            {message: success_message, status: 200} :
            {message: failure_message, status: 400}
    end
end
