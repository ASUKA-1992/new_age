class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :event_type, null:false   #タイプ  0:出来事 1:年間推移
      t.boolean :is_fake, null:false #虚構フラグ　0:事実、1:フィクション
      t.boolean :is_active, null:false #有効フラグ　0:無効、1:有効
      t.date :date, null:false      #年月日
      t.string :title, null:false   #出来事タイトル
      t.text :detail                #出来事詳細
      t.integer :population_change  #人口増減
      t.string :half_sinking        #50%沈没都道府県カンマ区切り
      t.string :sinking             #沈没都道府県カンマ区切り
      t.timestamps
    end
  end
end
