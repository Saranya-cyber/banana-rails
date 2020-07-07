class DonationSerializer < ActiveModel::Serializer
  attributes :id,
    :created_at,
    :updated_at,
    :donor_id,
    :food_name,
    :category,
    :total_amount,
    :pickup_instructions,
    :status

end
