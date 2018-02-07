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

ActiveRecord::Schema.define(version: 20180207222811) do

  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "user_name"
    t.string "password_digest"
    t.string "phone_number"
    t.string "email"
    t.string "confirm_token"
    t.boolean "email_confirmed"
    t.integer "institution_id"
    t.integer "admin_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_admins_on_institution_id"
  end

  create_table "books", force: :cascade do |t|
    t.integer "num_in_institution"
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "institution_id"
    t.boolean "sold"
    t.index ["institution_id"], name: "index_books_on_institution_id"
    t.index ["seller_id"], name: "index_books_on_seller_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["institution_id"], name: "index_groups_on_institution_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.integer "tickets_per_book"
    t.integer "books_per_seller"
    t.string "draw_date"
    t.integer "ticket_price"
    t.integer "max_books_per_seller"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.string "name"
    t.string "rut"
    t.string "password_digest"
    t.string "email"
    t.integer "phone_number"
    t.integer "num_in_institution"
    t.integer "num_of_logins"
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_name"
    t.integer "institution_id"
    t.index ["group_id"], name: "index_sellers_on_group_id"
    t.index ["institution_id"], name: "index_sellers_on_institution_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "phone_number"
    t.integer "num_in_book"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sold", default: false
    t.index ["book_id"], name: "index_tickets_on_book_id"
  end

end
