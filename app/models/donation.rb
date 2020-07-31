class Donation < ApplicationRecord

	belongs_to :donor
	has_many :claims, autosave: true

	validates :food_name, presence: true
	validates :category, presence: true
	validates :total_amount, presence: true
	validates :pickup_instructions, presence: true
	validates :donor_id, presence: true
	validates :status, presence: true
end
