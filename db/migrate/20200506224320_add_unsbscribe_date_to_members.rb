class AddUnsbscribeDateToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :unsbscribe_date, :timestamps
  end
end
