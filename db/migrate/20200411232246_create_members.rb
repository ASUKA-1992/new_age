class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name, null: false, unique: true     #ユーザー名
      t.string :mail, null: false, unique: true     #メールアドレス
      t.boolean :admin, null: false    #管理者フラグ
      t.timestamps
    end
  end
end
