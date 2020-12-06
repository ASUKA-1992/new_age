class CreatePrefectures < ActiveRecord::Migration[5.2]
  def change
    create_table :prefectures do |t|
      t.integer :Hokkaido, null:false
      t.integer :Aomori, null:false
      t.integer :Iwate, null:false
      t.integer :Miyagi, null:false
      t.integer :Akita, null:false
      t.integer :Yamagata, null:false
      t.integer :Fukushima, null:false
      t.integer :Ibaraki, null:false
      t.integer :Tochigi, null:false
      t.integer :Gunma, null:false
      t.integer :Saitama, null:false
      t.integer :Chiba, null:false
      t.integer :Tokyo, null:false
      t.integer :Kanagawa, null:false
      t.integer :Niigata, null:false
      t.integer :Toyama, null:false
      t.integer :Ishikawa, null:false
      t.integer :Fukui, null:false
      t.integer :Yamanashi, null:false
      t.integer :Nagano, null:false
      t.integer :Gifu, null:false
      t.integer :Shizuoka, null:false
      t.integer :Aichi, null:false
      t.integer :Mie, null:false
      t.integer :Shiga, null:false
      t.integer :Kyoto, null:false
      t.integer :Osaka, null:false
      t.integer :Hyogo, null:false
      t.integer :Nara, null:false
      t.integer :Wakayama, null:false
      t.integer :Tottori, null:false
      t.integer :Shimane, null:false
      t.integer :Okayama, null:false
      t.integer :Hiroshima, null:false
      t.integer :Yamaguchi, null:false
      t.integer :Tokushima, null:false
      t.integer :Kagawa, null:false
      t.integer :Ehime, null:false
      t.integer :Kochi, null:false
      t.integer :Fukuoka, null:false
      t.integer :Saga, null:false
      t.integer :Nagasaki, null:false
      t.integer :Kumamoto, null:false
      t.integer :Oita, null:false
      t.integer :Miyazaki, null:false
      t.integer :Kagoshima, null:false
      t.integer :Okinawa, null:false
      t.integer :Others, null:false
      t.timestamps
    end
  end
end
