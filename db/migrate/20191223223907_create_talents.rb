#タレントTBLのマイグレーションスクリプト
class CreateTalents < ActiveRecord::Migration[5.2]
  def change
    create_table :talents do |t|
      t.string :name, null: false     #氏名
      t.string :name_yomi, null:false #氏名よみ
      t.string :talent_name           #ニックネーム
      t.string :talent_name_yomi      #ニックネームよみ
      t.boolean :is_use_talent_name, null:false   #タレント名使用フラグ(1なら芸名使用)
      t.integer :sex, null:false      #性別(0:女性,1:男性,2:その他,3:答えたくない)
      t.string  :sex_remarks          #性別備考
      t.date :birth_date, null:false  #生年月日(YYYYmmDD)
      t.integer :residence, null:false  #居住都道府県
      t.string :residence_remarks     #居住都道府県備考
      t.string :roles, null:false     #種別
      t.text :detail, null:false      #説明
      t.string :mail_address, null:false, unique: true #メールアドレス
      t.string :phone_number, null:false, unique: true #電話番号
      t.date :unsubscribe_bate        #退会日
      t.string :password_digest, null: false #パスワード
      t.timestamps
    end
  end
end
