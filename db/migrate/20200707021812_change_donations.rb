class ChangeDonations < ActiveRecord::Migration[6.0]
  def change
    remove_column :donations, :measurement
    remove_column :donations, :per_person
    remove_column :donations, :total_servings
    remove_column :donations, :duration_minutes
    remove_column :donations, :image_url
    remove_column :donations, :canceled
    remove_column :donations, :pickup_location
    add_column :donations, :category, :string
    add_column :donations, :total_amount, :string
    add_column :donations, :pickup_instructions, :string
    add_column :donations, :status, :string
  end
end
