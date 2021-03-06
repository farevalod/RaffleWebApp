class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_action :authorize_seller_s_admin
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_ticket

  # GET /tickets
  # GET /tickets.json
  def index
    if params[:book_id]
      @tickets = Ticket.where(book_id: params[:book_id])
      @book_sold = @tickets.last.sold
    else
      # @tickets = Ticket.all
      redirect_to books_url, notice: "Debes seleccionar un talonario"
    end
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # # No se usa el new pues no se crean boletos independientes. Solo se crean con el talonario.
  #
  # # GET /tickets/new
  # def new
  #   @ticket = Ticket.new
  # end

  # GET /tickets/1/edit
  def edit
  end

  # # No se usa el create pues no se crean boletos independientes. Solo se crean con el talonario.
  #
  # # POST /tickets
  # # POST /tickets.json
  # def create
  #   @ticket = Ticket.new(ticket_params)
  #
  #   respond_to do |format|
  #     if @ticket.save
  #       format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
  #       format.json { render :show, status: :created, location: @ticket }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @ticket.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.set_corresponding_ticket(params[:id], session[:admin_id], session[:user_id])
    if @ticket
      @ticket
    else
      invalid_ticket
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:name, :email, :phone_number, :num_in_book, :book_id)
  end

  def invalid_ticket
    logger.error "Intento de acceder a un boleto(#{params[:id]}) no válido"
    redirect_to books_url, notice: 'Boleto no válido!'
  end

end
