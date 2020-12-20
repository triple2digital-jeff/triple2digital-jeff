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

ActiveRecord::Schema.define(version: 2020_03_16_040911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.string "start_time"
    t.string "end_time"
    t.bigint "service_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.boolean "is_booked", default: false
    t.integer "working_day_id"
    t.date "appointment_date"
    t.index ["service_id"], name: "index_appointments_on_service_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_users", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "charges", force: :cascade do |t|
    t.integer "user_id"
    t.float "amount"
    t.string "stripe_id"
    t.float "company_share"
    t.integer "owner_id"
    t.integer "event_id"
    t.boolean "approved", default: false
    t.boolean "disputed", default: false
    t.boolean "boolean", default: false
    t.boolean "refunded", default: false
    t.text "stripe_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "last_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "description"
    t.bigint "post_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "endorsements", force: :cascade do |t|
    t.integer "endorsed_by_id"
    t.integer "endorsed_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "endorsments", force: :cascade do |t|
    t.integer "endorse_by"
    t.integer "endorse_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer "owner_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string "title"
    t.text "description"
    t.string "status"
    t.float "price", default: 0.0
    t.boolean "is_paid", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "dress_code"
    t.string "speaker"
    t.text "cover_image", default: "http://app.profilerlife.com/images/default_cover.png"
    t.boolean "has_published", default: false
    t.integer "max_tickets", default: 0
    t.boolean "is_recurring", default: false
    t.integer "recurring_type", default: 0
    t.integer "is_enabled", default: 0
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "sender_id"
    t.integer "receiver_id"
    t.integer "chat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outgoing_payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "status", default: 0
    t.float "amount", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.float "amount"
    t.integer "user_id"
    t.integer "event_id"
    t.integer "status", default: 0
    t.string "stripe_payment_id"
    t.string "stripe_transfer_id"
    t.text "stripe_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_likes", force: :cascade do |t|
    t.integer "liked_by_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_likes_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "description"
    t.string "image_url"
    t.string "video_url"
    t.string "privacy"
    t.string "post_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.boolean "is_hidden", default: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "report_posts", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "user_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_report_posts_on_post_id"
    t.index ["user_id"], name: "index_report_posts_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.integer "rating", default: 0
    t.integer "reviewable_id"
    t.string "reviewable_type"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "saved_events", force: :cascade do |t|
    t.integer "saveable_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "saveable_type"
  end

  create_table "service_categories", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.text "note"
    t.float "price"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_private", default: false
    t.string "duration"
    t.string "time_type", default: "minutes"
    t.text "cover_image", default: "http://app.profilerlife.com/images/default_cover.png"
    t.integer "service_category_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_skills_on_category_id"
  end

  create_table "sub_skills", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.bigint "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_sub_skills_on_skill_id"
  end

  create_table "ticket_packages", force: :cascade do |t|
    t.string "ticket_type"
    t.float "price", default: 0.0
    t.integer "maximum_tickets", default: 0
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "owner_id"
    t.boolean "is_expired"
    t.integer "event_id"
    t.integer "ticket_package_id"
    t.datetime "expire_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_scanned", default: false
  end

  create_table "user_connections", force: :cascade do |t|
    t.integer "user_id"
    t.integer "connection_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_devices", force: :cascade do |t|
    t.text "push_token"
    t.boolean "is_active", default: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_devices_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "gender"
    t.string "address"
    t.string "api_token"
    t.string "role"
    t.string "provider"
    t.string "uid"
    t.boolean "is_skilled", default: false
    t.integer "skill_id"
    t.integer "sub_skill_id"
    t.string "confirmation_token"
    t.string "unconfirmed_email"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "dob"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "zipcode"
    t.string "profile_img", default: "http://app.profilerlife.com/images/user.png"
    t.string "cover_img", default: "http://app.profilerlife.com/images/default_cover.png"
    t.float "latitude"
    t.float "longitude"
    t.string "age"
    t.string "stripe_token"
    t.string "stripe_payout_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "working_days", force: :cascade do |t|
    t.integer "work_day"
    t.string "start_time"
    t.string "end_time"
    t.boolean "opened"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "has_break", default: false
    t.string "break_start_time"
    t.string "break_end_time"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
