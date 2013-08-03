class ChangePasswordToBinaryOnUser < ActiveRecord::Migration
  def up
    change_column :users, :password, :binary
  end

  def down
    change_column :users, :password, :string
  end
end
