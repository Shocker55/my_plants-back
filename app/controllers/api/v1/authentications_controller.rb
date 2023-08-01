class Api::V1::AuthenticationsController < ApplicationController
  def create
    if current_user
      render json: { status: 'success', message: "User successfully logged in!"}
    else
      render status: :unauthorized, json: { status: 'ERROR', message: 'No current user' }
    end
  end
end