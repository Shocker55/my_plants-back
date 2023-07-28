class Api::V1::UsersController < ApplicationController
  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find_by(params[:id])
    render json: user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: {message: "不正な値です", errors: @user.errors.to_hash(true)}, status: 422
    end
  end

  def update
  end


  private

  def user_params
    params.require(:user).permit(:uid, :name, :avatar, :bio)
  end
end
