class CreateConsts < ActiveRecord::Migration[5.2]
  def change
    create_table :consts do |t|
      t.string :key, null:false  #キー
      t.integer :value, null:false  #値
      t.timestamps
    end
  end
end
