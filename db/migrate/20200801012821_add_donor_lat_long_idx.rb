class AddDonorLatLongIdx < ActiveRecord::Migration[6.0]
  def change
    add_index :donors, [:latitude, :longitude]
  end
end
