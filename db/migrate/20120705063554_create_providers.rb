class CreateProviders < ActiveRecord::Migration
  def up
    remove_column :authentications, :provider
    add_column    :authentications, :provider_id, :integer

    create_table :providers do |t|
      t.string :name
      t.timestamps
    end

    # Create default set of providers
    Provider.create(:name => "twitter")
  end

  def down
    add_column    :authentications, :provider, :string
    remove_column :authentications, :provider_id

    drop_table :providers
  end
end
