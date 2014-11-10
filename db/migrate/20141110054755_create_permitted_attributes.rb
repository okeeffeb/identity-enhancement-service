class CreatePermittedAttributes < ActiveRecord::Migration
  def change
    create_table :permitted_attributes do |t|
      t.references :provider, null: false, default: nil
      t.string :value, null: false, default: nil
      t.timestamps

      t.index :provider_id
    end
  end
end
