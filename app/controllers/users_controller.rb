class UsersController < ApplicationController
  before_action :authenticate_user!


  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout 'home'
  # GET /users
  # GET /users.json
  def index
    # byebug
    options = {
        # keyword: params[:keyword],
        latitude: params[:latitude],
        longitude: params[:longitude],
        distance: params[:distance],
        category: params[:category],
        min_age: params[:min_age],
        max_age: params[:max_age],
        skilled: params[:skilled],
        gender: params[:gender],
        skill: params[:skill],
        sub_skill: params[:sub_skill],
    }
    @users = User.search(options).includes(:posts).page(params[:page])

    # @users = User.where(search_condition(User)).includes(:posts).page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new_admin
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
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
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
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :phone, :gender, :address, :is_skilled)
  end

end
