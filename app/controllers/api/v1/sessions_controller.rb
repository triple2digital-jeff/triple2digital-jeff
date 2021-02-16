class Api::V1::SessionsController < ApplicationController

  before_action :find_user, only: [:create]

  def new

  end

  def create
    @user = User.where(email: params[:email]).first
    if @user && @user.valid_password?(params[:password])
      @user.update_user_api_token(create_new=true)
      @user.reload
      @user.setup_devices(params[:PushToken],params[:platform]) if params[:PushToken].present?
      render json: @user, status: :created
    else
      render :json => {:error => "Email or password is not correct"}, :status => 404
    end
  end

  def destroy
    user = User.where(id: params[:id]).first
    if user
      user.update_user_api_token(create_new=false)
      user.reload
      render json: user.as_json, status: :created
    else
      render :json => {:error => "User not found"}, :status => 404
    end
  end

  def find_user
    begin
      @user = User.find_by_email(params[:email])
      render :json => {:error => "User is not activated. Please check your email #{@user.email} for user activation."} unless @user.is_confirmed
    rescue
      render :json => {:error => "User not found with provided id"}, :status => 404
    end
  end

end