class AddClmAdminInUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :admin, :boolean, null: false, default: false, after: :sign_in_count
  end
end