class UsersController < ApplicationController

  def create
    logger.info "============== ============ CREATE ============== ============"
    logger.info params
    logger.info params[:password]
    #logger.info user_params
    user = User.new(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    user.update(:admin => false)
  
    if user.save
      render json: {status: 'User created successfully', user_id: user.id, admin: user.admin}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end


  def login
    logger.info "============== ============ LOGIN ============== ============"
    logger.info params
    logger.info params[:email]
    logger.info params[:password]

    user = User.find_by(email: params[:email].to_s.downcase)
  
    if user && user.authenticate(params[:password])
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {auth_token: auth_token, user_id: user.id, admin: user.admin}, status: :ok
        #render json: {status: 'User logged in successfully'}, status: :ok
    else
      render json: {error: 'Invalid username / password'}, status: :unauthorized
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end



  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

=begin
  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end


  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :dob, :email, :password_digest, :admin, :password_confirmation, :password)
    end
=end

end
