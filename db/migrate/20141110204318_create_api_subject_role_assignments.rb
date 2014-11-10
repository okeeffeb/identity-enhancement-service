class CreateAPISubjectRoleAssignments < ActiveRecord::Migration
  def change
    create_table :api_subject_role_assignments do |t|
      t.references :api_subject, null: false, default: nil
      t.references :role, null: false, default: nil
      t.timestamps
    end
  end
end
