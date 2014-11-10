class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :provider, null: false, default: nil
      t.string :identifier, null: false, default: nil
      t.string :email, null: false, default: nil
      t.boolean :available, null: false, default: true
      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
