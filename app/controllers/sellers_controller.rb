class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin
  skip_before_action :authorize_admin, only: :show
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_seller

  # GET /sellers
  # GET /sellers.json
  def index
    @sellers, @admin_level = Seller.select_sellers_to_show(session[:admin_id])
  end

  # GET /sellers/1
  # GET /sellers/1.json
  def show
    @admin = Admin.find_by(id: session[:admin_id])
    @books = Book.where(seller_id: @seller.id)
  end

  # GET /sellers/new
  def new
    @seller = Seller.new
  end

  # GET /sellers/1/edit
  def edit
  end

  # POST /sellers
  # POST /sellers.json
  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        @seller.init_seller
        format.html { redirect_to sellers_url, notice: 'Seller was successfully created.' }
        format.json { render :show, status: :created, location: @seller }
      else
        format.html { render :new }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sellers/1
  # PATCH/PUT /sellers/1.json
  def update
    respond_to do |format|
      if @seller.update(seller_params)
        format.html { redirect_to @seller, notice: 'Seller was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sellers/1
  # DELETE /sellers/1.json
  def destroy

    @seller.del_seller_books_and_tickets
    #@seller.destroy

    respond_to do |format|
      format.html { redirect_to sellers_url, notice: 'Seller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seller
    @seller = Seller.set_corresponding_seller(params[:id], session[:admin_id], session[:user_id])
    if @seller
      @seller
    else
      invalid_seller
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seller_params
    params.require(:seller).permit(:name, :rut, :password, :password_confirmation, :email, :phone_number, :num_in_institution, :num_of_logins, :email_confirmed, :confirm_token, :group_id, :institution_id)
  end

  def invalid_seller
    logger.error "Intento de acceder a un vendedor(#{params[:id]}) no válido"
    redirect_to sellers_url, notice: 'Vendedor no válido!'
  end

end
