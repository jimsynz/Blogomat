class ChangePasswordToBinaryOnUser < ActiveRecord::Migration
  def up
    remove_column :users, :password, :string
    add_column    :users, :password, :binary
  end

  def down
    remove_column :users, :password, :binary
    add_column    :users, :password, :string
  end
end
