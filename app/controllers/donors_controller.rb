require 'account_status_helper'
class DonorsController < ApplicationController
    skip_before_action :authorized, only: [:create]

	def get_donations
		id = params[:id].to_i
		authorized_id = decoded_token[0]['donor_id']
		if id != authorized_id
			render json: { error: 'Unauthorized' }, status: :forbidden
			return
		end
		@donor = Donor.find(id)

		render json: @donor.donations, include: 'claims', status: :ok
	end

	def create
		return render json: { error: 'donor email already in use'}, status: :conflict if Donor.exists?({email: donor_params(false)[:email]})
        params['donor']['account_status'] = 'processing'
		@donor = Donor.create!(donor_params(true))
		if @donor.valid?
			@token = encode_token(donor_id: @donor.id)
			session[:donor_id] = @donor.id
			render json: { donor: DonorSerializer.new(@donor), jwt: @token }, status: :created
		else
            @donor.errors.full_messages
            render json: { error: 'failed to create donor' }, status: :bad_request
        end
    end
    
    def activate
        id = params[:id].to_i
        @donor = Donor.find_by_id(id)
        if @donor.nil?
           failure_message = { error: "ID: #{params[:id]} not found" }
           return render  json: failure_message, status: :not_found
        end
        status = @donor.account_status
        response = AccountStatusHelper.activate("Donor", @donor, status, id)
        return render json: response[:message], status: response[:status]
    end
    
	def account_status_update
		id = params[:id].to_i
		status = params[:status]

		@donor = Donor.find_by_id(id)
        if @donor.nil?
           failure_message = { error: "ID: #{params[:id]} not found" }
           return render  json: failure_message, status: :not_found
        end
		
        response = AccountStatusHelper.account_status("Donor", @donor, status, id)
        return render json: response[:message], status: response[:status]
	end

    
	def update
		@donor = Donor.find_by_id(params[:id])
        if @donor.nil?
           failure_message = { error: "ID: #{params[:id]} not found" }
           return render  json: failure_message, status: :not_found
        end
		if @donor.update(donor_params(false))
			render json: @donor
		else
			failure_message = {}
            failure_message['message'] = "Donor id: #{params[:id]} was not updated."
            failure_message['field_errors'] = []
            @donor.errors.each do |attr_name, attr_value|
                message = {}
                message['field'] = attr_name
                message['message'] = attr_value
                failure_message['field_errors'] << message
            end
            render json: failure_message, status: :bad_request
		end
	end

    
	def scan_qr_code
		claim = JSON.parse(Base64.decode64(params[:qr_code]))
		@claim = Claim.find_by(client_id: claim.client_id, donation_id: claim.donation_id)
		if @claim
			if !@claim.completed
				@claim.completed = true
				@claim.save
				render json: { message: 'claim completed' }, status: :accepted
				return
			else
				render json: { error: 'claim has already been completed'}, status: :unprocessable_entity
			end
		else
			render json: { error: 'claim not found' }, status: :unprocessable_entity
		end
	end

	private

	def donor_params(shouldPermitAccountStatus)
        if shouldPermitAccountStatus
            params.require(:donor).permit(
			   :email,
			   :password,
			   :first_name,
			   :last_name,
			   :organization_name,
			   :address_street,
			   :address_city,
			   :address_state,
			   :address_zip,
               :pickup_instructions,
			   :account_status
			   # :business_license,
			   # :business_phone_number,
			   # :business_doc_id,
			   # :profile_pic_link
		   )
        else
           params.require(:donor).permit(
              :id,
              :email,
              :password,
              :first_name,
              :last_name,
              :organization_name,
              :address_street,
              :address_city,
              :address_state,
              :address_zip,
              :pickup_instructions
              # :business_license,
              # :business_phone_number,
              # :business_doc_id,
              # :profile_pic_link
           )
        end
	end
end

