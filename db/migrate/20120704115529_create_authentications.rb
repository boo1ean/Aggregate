class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string  :provider
      t.string  :uid
      t.string  :token
      t.string  :secret

      t.timestamps
    end

    add_index :authentications, :user_id
    add_index :authentications, [:user_id, :provider], :unique => true
    add_index :authentications, :uid
  end
end
