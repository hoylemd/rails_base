class RenameUsersActivationToUsersVerification < ActiveRecord::Migration
  def change
    rename_column :users, :activation_digest, :verification_digest
    rename_column :users, :activated_at, :verified_at
    rename_column :users, :activated, :verified
  end
end
