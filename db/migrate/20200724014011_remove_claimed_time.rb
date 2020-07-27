class RemoveClaimedTime < ActiveRecord::Migration[6.0]
  def change
    remove_column :claims, :time_claimed
  end
end
