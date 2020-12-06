class AddPolluionToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :pollution, :string
    add_column :events, :half_pollution, :string
  end
end
