class Api::V1::ProfilesController < ApplicationController

  def show
    user = User.find_by(uid: params[:id])
    if user.profile
      render json: {profile:"exist"}
    else
      render json: {profile:"not exist"}
    end
  end

  def create
    @profile = current_user.build_profile(profile_params)
    if @profile.save
      head :created
    else
      render json: {message: "不正な値です", errors: @profile.errors.to_hash(true)}, status: 422
    end
  end

  def edit
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :avatar, :bio)
  end
end
