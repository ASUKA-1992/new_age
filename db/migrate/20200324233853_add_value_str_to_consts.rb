class AddValueStrToConsts < ActiveRecord::Migration[5.2]
  def change
    add_column :consts, :value_str, :sring
  end
end
