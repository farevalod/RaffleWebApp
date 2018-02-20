class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin
  skip_before_action :authorize_admin, only: :show
  before_action :validate_group_to_create, only: [:new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_seller

  # GET /sellers
  # GET /sellers.json
  def index
    @sellers, @admin_level = Seller.select_sellers_to_show(session[:admin_id])
    @group_id = nil
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
    @group_id = params[:group_id]
    puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
    puts 'GROUP ID: ' + @group_id
    puts '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'
  end

  # GET /sellers/1/edit
  def edit
  end

  # POST /sellers
  # POST /sellers.json
  def create
    parameters = create_seller_params
    parameters[:rut] = rut_formatter(parameters[:rut])
    parameters[:user_name] = remove_non_alnum(remove_accent_marks(parameters[:name])).downcase
    parameters[:password] = parameters[:rut].tr('.','').tr('-','')[-5..-2]
    parameters[:num_of_logins] = 0
    parameters[:institution_id] = Admin.find(session[:admin_id]).institution_id
    parameters[:group_id] = params[:group_id]


    @seller = Seller.new(parameters)

    respond_to do |format|
      if @seller.save
        @seller.init_seller
        format.html { redirect_to sellers_url, notice: "Se creó el vendedor #{parameters[:name]}!" }
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
      if @seller.update(update_seller_params)
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

  # # Never trust parameters from the scary internet, only allow the white list through.
  # def seller_params
  #   params.require(:seller).permit(:name, :rut, :password, :password_confirmation, :email, :phone_number, :num_in_institution, :num_of_logins, :email_confirmed, :confirm_token, :group_id, :institution_id)
  # end

  def invalid_seller
    logger.error "Intento de acceder a un vendedor(#{params[:id]}) no válido"
    redirect_to sellers_url, notice: 'Vendedor no válido!'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_seller_params
    params.require(:seller).permit(:name, :rut, :group_id, :institution_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def update_seller_params
    params.require(:seller).permit(:name, :rut, :password, :password_confirmation, :email, :phone_number, :num_in_institution, :num_of_logins, :email_confirmed, :confirm_token, :group_id, :institution_id)
  end

  def validate_group_to_create
    group_id = params[:group_id]
    admin = Admin.find_by(id: session[:admin_id])
    if group_id
      # Si el grupo no pertenece a la institución:
      unless admin.institution.groups.include?(Group.find_by(id: group_id))
        logger.error "Intento de crear a un vendedor en un grupo(#{params[:group_id]}) no válido"
        redirect_to groups_url, notice: 'Grupo no válido!'
      end
    # Si se intenta crear un vendedor sin grupo:
    else
      logger.error "Intento de crear a un vendedor sin grupo"
      redirect_to groups_url, notice: 'Para agregar un vendedor debes seleccionar un grupo.'
    end


  end

end
