class CreateSubjectRoleAssignments < ActiveRecord::Migration
  def change
    create_table :subject_role_assignments do |t|
      t.references :subject, null: false, default: nil
      t.references :role, null: false, default: nil
      t.timestamps
    end
  end
end
