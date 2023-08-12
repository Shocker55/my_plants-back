class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    users = Profile.all
    render json: users
  end

  def show
    user = Profile.find_by(user_id: params[:id])
    render json: user
  end

  def update; end
end
