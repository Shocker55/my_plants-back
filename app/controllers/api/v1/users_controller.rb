class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    users = User.all
    render json: users, include: [:profile]
  end

  def show
    user = User.find_by(uid: params[:id])
    render json: user, include: [:profile]
  end

  def likes
    user = User.find_by(uid: params[:id])
    like_records = user.like_records
    render json: like_records, include: [record_likes: { include: :user }, user: { include: :profile }]
  end
end
