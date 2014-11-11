class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :provider, null: false, default: nil
      t.references :subject, null: false, default: nil
      t.string :identifier, null: false, default: nil
      t.string :email, null: false, default: nil
      t.boolean :used, null: false, default: false
      t.timestamp :expires, null: false, default: nil
      t.timestamps

      t.index :identifier, unique: true
    end
  end
end
