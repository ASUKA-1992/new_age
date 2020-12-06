class AddDefaultFlgToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :delault_flg, :boolean
  end
end
