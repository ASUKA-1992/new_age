class AddMemberIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :member_id, :integer
  end
end
