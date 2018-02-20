class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin
  skip_before_action :authorize_admin, only: :confirm_email
  skip_before_action :authorize, only: :confirm_email
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_admin


  # GET /admins
  # GET /admins.json
  def index
    @admins, @num = Admin.select_admins_to_show(session[:admin_id])
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
    @admin_level = Admin.find(session[:admin_id]).admin_level
  end

  # GET /admins/new
  def new
    @admin = Admin.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins
  # POST /admins.json
  def create
    # Solo un admin puede crear otro admin. Verificado por authorize_admin
    admin = Admin.find_by(id: session[:admin_id])
    create_params = create_admin_params
    create_params[:user_name] = remove_non_alnum(remove_accent_marks(create_params[:name])).downcase
    create_params[:institution_id] = admin.institution.id
    create_params[:password] = create_params[:rut].tr('.','').tr('-','')[-5..-2]
    create_params[:admin_level] = 4

    @admin = Admin.new(create_params)
    respond_to do |format|
      if @admin.save
        AdminMailer.registration_confirmation(@admin, Admin.find(session[:admin_id])).deliver
        format.html { redirect_to @admin, notice: "Se ha creado el nuevo administrador #{@admin.name}!" }
        format.json { render :show, status: :created, location: @admin }
      else
        format.html { render :new }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(update_admin_params)
        format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirm_email
    admin = Admin.find_by_confirm_token(params[:id])
    if admin
      admin.email_activate
      flash[:notice] = "Tu email ha sido confirmado! Por favor inicia sesión."
      redirect_to login_admin_url
    else
      flash[:notice] = "El usuario no existe o este email ya fue confirmado."
      redirect_to main_page_url
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.set_corresponding_admin(params[:id], session[:admin_id])
    if @admin
      @admin
    else
      invalid_admin
    end
  end

  def invalid_admin
    logger.error "Intento de acceder a un administrador(#{params[:id]}) no válido"
    redirect_to admins_url, notice: 'Administrador no válido!'
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_admin_params
    params.require(:admin).permit(:name, :phone_number, :email, :rut)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def update_admin_params
    params.require(:admin).permit(:name, :user_name, :password, :password_confirmation, :phone_number, :email, :confirm_token, :email_confirmed, :institution_id, :admin_level)
  end

end
