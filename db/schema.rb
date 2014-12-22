# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141222031312) do

  create_table "api_subject_role_assignments", force: true do |t|
    t.integer  "api_subject_id", null: false
    t.integer  "role_id",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_subjects", force: true do |t|
    t.integer  "provider_id",                 null: false
    t.string   "x509_cn",                     null: false
    t.string   "description",  default: "",   null: false
    t.string   "contact_name",                null: false
    t.string   "contact_mail",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",      default: true, null: false
  end

  create_table "audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "available_attributes", force: true do |t|
    t.string   "name",        null: false
    t.string   "value",       null: false
    t.string   "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.integer  "provider_id",                 null: false
    t.integer  "subject_id",                  null: false
    t.string   "identifier",                  null: false
    t.string   "name",                        null: false
    t.string   "mail",                        null: false
    t.boolean  "used",        default: false, null: false
    t.datetime "expires",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["identifier"], name: "index_invitations_on_identifier", unique: true, using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "role_id",    null: false
    t.string   "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["role_id"], name: "index_permissions_on_role_id", using: :btree

  create_table "permitted_attributes", force: true do |t|
    t.integer  "provider_id",            null: false
    t.integer  "available_attribute_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permitted_attributes", ["provider_id"], name: "index_permitted_attributes_on_provider_id", using: :btree

  create_table "provided_attributes", force: true do |t|
    t.integer  "permitted_attribute_id", null: false
    t.integer  "subject_id",             null: false
    t.string   "name",                   null: false
    t.string   "value",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provided_attributes", ["subject_id"], name: "index_provided_attributes_on_subject_id", using: :btree

  create_table "providers", force: true do |t|
    t.string   "name",                     null: false
    t.string   "description", default: "", null: false
    t.string   "identifier",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.integer  "provider_id"
    t.string   "name",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["provider_id"], name: "index_roles_on_provider_id", using: :btree

  create_table "subject_role_assignments", force: true do |t|
    t.integer  "subject_id", null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "name",                         null: false
    t.string   "mail",                         null: false
    t.string   "targeted_id"
    t.string   "shared_token"
    t.boolean  "complete",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",      default: true,  null: false
  end

  add_index "subjects", ["shared_token"], name: "index_subjects_on_shared_token", unique: true, using: :btree
  add_index "subjects", ["targeted_id"], name: "index_subjects_on_targeted_id", using: :btree

end
