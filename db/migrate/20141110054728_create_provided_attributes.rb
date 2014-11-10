class CreateProvidedAttributes < ActiveRecord::Migration
  def change
    create_table :provided_attributes do |t|
      t.references :provider, null: false, default: nil
      t.references :subject, null: false, default: nil
      t.string :name, null: false, default: nil
      t.string :value, null: false, default: nil
      t.timestamps

      t.index :subject_id
    end
  end
end
