class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find_by(uid: params[:id])
    render json: user
  end

  def update
  end


  private

  def user_params
    params.require(:user).permit(:uid, :name, :avatar, :bio)
  end
end
