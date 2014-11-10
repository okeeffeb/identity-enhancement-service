class CreateAPISubjects < ActiveRecord::Migration
  def change
    create_table :api_subjects do |t|
      t.references :provider, null: false, default: nil
      t.string :x509_cn, null: false, default: nil
      t.string :name, null: false, default: nil
      t.timestamps
    end
  end
end
