class SellTicketsController < ApplicationController
  def create
    params[:tickets_ids].each do |ticket_id|
      Ticket.find(ticket_id).sell(params[:name], params[:email], params[:phone_number])
    end
    redirect_to tickets_url(book_id: params[:book_id])
  end

  def new
    # # Este código sirve para convertir arrreglos en un formato que se pueda pasar por la URL
    # data = { tickets_ids: params[:tickets_ids] }
    # @tickets_ids = CGI.unescape data.to_query
  end
end
