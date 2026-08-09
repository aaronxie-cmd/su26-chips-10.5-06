class AddContactDetailsToRepresentatives < ActiveRecord::Migration[7.2]
  def change
    add_column :representatives, :address, :string
    add_column :representatives, :phone, :string
    add_column :representatives, :url, :string
  end
end
