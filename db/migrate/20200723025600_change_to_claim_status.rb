class ChangeToClaimStatus < ActiveRecord::Migration[6.0]
  def change
    remove_column :claims, :completed
    remove_column :claims, :canceled
    add_column :claims, :status, :string
  end
end
