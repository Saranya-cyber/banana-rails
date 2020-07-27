class DonationSerializer < ActiveModel::Serializer
  attributes :id,
    :created_at,
    :updated_at,
    :donor_id,
    :food_name,
    :category,
    :total_amount,
    :pickup_instructions,
    :status,
    :donor
  #only return donor address info
  def donor
    {address_city: self.object.donor.address_city,
     address_street: self.object.donor.address_street,
     address_state: self.object.donor.address_state,
     address_zip: self.object.donor.address_zip,
     latitude: self.object.donor.latitude,
     longitude: self.object.donor.longitude}
  end

end
