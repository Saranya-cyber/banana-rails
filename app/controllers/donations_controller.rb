require 'base64'

class DonationsController < ApplicationController
	before_action :authorized

	def index
		render json: Donation.all
	end

	def active
		@active_donations_in_db = Donation.where status: DonationStatus::ACTIVE
		render json: expire_donations(@active_donations_in_db)
	end

	def show
		render json: Donation.find(params[:id])
	end

	def create
		@donation = Donation.create(donation_params)
		if @donation.valid?
			render json: { donation: DonationSerializer.new(@donation) }, status: :created
		else
			render json: { error: 'failed to create donation', errors: @donation.errors.full_messages }, status: :unprocessable_entity
		end
	end

	def update
		id = params[:id].to_i
		@donation = Donation.find(id)
		authorized_id = decoded_token[0]['donor_id']
		if authorized_id != @donation.donor_id
			return render json: { error: 'unauthorized'}, status: :unauthorized
		end
		if @donation.update(donation_params)
			render json: { donation: DonationSerializer.new(@donation) }, status: :accepted
		else
			render json: { error: 'failed to update donation' }, status: :unprocessable_entity
		end
	end

	def make_claim
		donation_id = params[:id]
		client_id = params[:client_id]

		# No multiple claims by one client on one donation
		if Claim.find_by(donation_id: donation_id, client_id: client_id)
			render json: { error: 'claim already exists for this client and donation' }, status: :unprocessable_entity
			return
		end

		qr_code = Base64.encode64({ 'client_id': params[:client_id], 'donation_id': params[:id] }.to_json).chomp
		claim_params = {
			client_id: params[:client_id],
			donation_id: params[:id],
			qr_code: qr_code,
			completed: false,
			time_claimed: Time.now,
			canceled: false,
		}
		@claim = Claim.new(claim_params)
		if @claim.valid?
			@claim.save
			render json: { claim: ClaimSerializer.new(@claim) }, status: :accepted
		else
			render json: { error: 'failed to create claim' }, status: :unprocessable_entity
		end
	end

	private

	def donation_params
		params.require(:donation).permit(
			:id,
			:donor_id,
			:category,
			:food_name,
			:pickup_instructions,
			:status,
			:total_amount,
		)
	end
end
