class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_book

  # GET /books
  # GET /books.json
  def index
    @admin = Admin.find(session[:admin_id])
    @user = User.find(session[:user_id])
    @books = Book.select_books_to_show(@admin, session[:user_id])
  end


  # GET /books/1
  # GET /books/1.json
  def show
    if Seller.find_by(id: session[:user_id])
      respond_to do |format|
        format.html { redirect_to controller: 'tickets', action: 'index', book_id: params[:id] }
      end
    end
  end

  # # No se crean talonarios por formularios:
  # # GET /books/new
  # def new
  #   @book = Book.new
  # end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    user = Seller.find_by(id: session[:user_id])
    books_quan = user.books.count
    max_books = user.institution.max_books_per_seller
    institution = user.institution
    book_num = institution.books.count + 1
    parameters = { num_in_institution: book_num,
                   seller_id: user.id,
                   institution_id: institution.id }

    if books_quan < max_books
      @book = Book.new(parameters)
      if @book.save
        @book.create_tickets
        redirect_to books_url , notice: 'Se ha agregado un nuevo talonario.'
      end
    else
      redirect_to books_url, notice: 'Has alcanzado el máximo de talonarios permitidos. Contáctate con tu institución.'
    end

    # respond_to do |format|
    #   if @book.save
    #     @book.create_tickets
    #     format.html { redirect_to @book, notice: 'Se ha cread el nuevo talonario!' }
    #     format.json { render :show, status: :created, location: @book }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @book.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.set_corresponding_book(params[:id], session[:admin_id], session[:user_id])
    if @book
      @book
    else
      invalid_book
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:num_in_institution, :seller_id)
  end

  def invalid_book
    logger.error "Intento de acceder a un talonario(#{params[:id]}) no válido"
    redirect_to books_url, notice: 'Talonario no válido!'
  end

end
