json.extract! institution, :id, :name, :tickets_per_book, :books_per_seller, :draw_date, :ticket_price, :max_books_per_seller, :created_at, :updated_at
json.url institution_url(institution, format: :json)
