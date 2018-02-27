class GroupsController < ApplicationController
  before_action :authorize_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_group

  # GET /groups
  # GET /groups.json
  def index
    @admin = Admin.find(session[:admin_id])
    @groups = Group.select_groups_to_show(@admin)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @sellers = Seller.where(group_id: params[:id]).order(:name)
    @group_id = params[:id]
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    parameters = group_params
    parameters[:institution_id] = Admin.find_by(id: session[:admin_id]).institution_id
    @group = Group.new(parameters)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "Se creó el grupo #{parameters[:name]}" }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.set_corresponding_group(params[:id], session[:admin_id])
    if @group
      @group
    else
      invalid_group
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name)
  end

  def invalid_group
    logger.error "Intento de acceder a un grupo(#{params[:id]}) no válido"
    redirect_to groups_url, notice: 'Grupo no válido!'
  end
  
end
