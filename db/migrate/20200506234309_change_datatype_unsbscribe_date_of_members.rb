class ChangeDatatypeUnsbscribeDateOfMembers < ActiveRecord::Migration[5.2]
  def change
    change_column :members, :unsbscribe_date, :string
  end
end
