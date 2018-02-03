json.extract! ticket, :id, :name, :email, :phone_number, :num_in_book, :book_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
