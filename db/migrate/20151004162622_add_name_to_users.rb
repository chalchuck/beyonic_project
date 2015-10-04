class AddNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :mobile_number, :string
    add_column :users, :mobile_verification_code, :string
    add_column :users, :authentication_code, :string
    add_column :users, :verified_at, :datetime
    
    add_index :users, :username, unique: true
    add_index :users, :mobile_number, unique: true
    add_index :users, :authentication_code, unique: true    
    add_index :users, :mobile_verification_code, unique: true
  end
end
