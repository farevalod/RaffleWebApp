class PaymentController < ApplicationController
  def new
  end

  def create
    quantity = params[:quantity].to_i
    book = Book.find(params[:book_id])
    pending = book.tickets_sold - book.tickets_paid

    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    puts book.tickets_sold
    puts book.tickets_paid
    puts pending
    puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'


    # A futuro hacer que si alguien paga más de los boletos que tiene pendiente entonces se le vendan los boletos a si
    # mismo. Esto previa advertencia y solicitud de aprobación al usuario.
    case
      when quantity <= 0
        redirect_to book_url(params[:book_id], params: {payment: true}), notice: "La cantidad de boletos debe ser mayor a cero"
      when quantity > pending
        redirect_to book_url(params[:book_id], params: {payment: true}), notice: "La cantidad ingresada es mayor a la cantidad de boletos pendientes por pagar de este talonario."
      else
        mark_tickets_as_paid(quantity)
        if quantity == pending
          mark_book_as_paid
        end
        redirect_to book_url(params[:book_id]), notice: "Ingresado correctamente"
    end
  end

  private

  def mark_tickets_as_paid(quantity)
    unpaid_ids = Ticket.where(book_id: params[:book_id]).where(sold: true).where(paid: false).ids
    quantity.times do |num|
      Ticket.find(unpaid_ids[num]).update(paid: true, paid_at: DateTime.now)
    end
  end

  def mark_book_as_paid
    Book.find(params[:book_id]).update(paid: true, paid_at: DateTime.now)
  end




end
