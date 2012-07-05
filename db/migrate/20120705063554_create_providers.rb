class CreateProviders < ActiveRecord::Migration
  def up
    remove_column :authentications, :provider
    add_column    :authentications, :provider_id, :integer
    add_column    :authentications, :expires_at,  :string

    create_table :providers do |t|
      t.string :name
      t.timestamps
    end

    # Create default set of providers
    Provider.create(:name => "twitter")
    Provider.create(:name => "facebook")
    Provider.create(:name => "vkontakte")
  end

  def down
    add_column    :authentications, :provider, :string
    remove_column :authentications, :provider_id
    remove_column :authentications, :expires_at

    drop_table :providers
  end
end
