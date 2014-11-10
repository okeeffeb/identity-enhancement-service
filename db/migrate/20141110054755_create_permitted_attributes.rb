class CreatePermittedAttributes < ActiveRecord::Migration
  def change
    create_table :permitted_attributes do |t|
      t.references :provider, null: false, default: nil
      t.references :available_attribute, null: false, default: nil
      t.timestamps

      t.index :provider_id
    end
  end
end
