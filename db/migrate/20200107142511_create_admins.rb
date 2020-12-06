class CreateAdmins < ActiveRecord::Migration[5.2]
  def change
    create_table :admins do |t|
      t.string :admin_id, null: false          #管理者ID
      t.string :password_digest, null: false   #パスワード
      t.timestamps
    end
  end
end
