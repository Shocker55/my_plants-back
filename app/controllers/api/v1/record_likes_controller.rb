class Api::V1::RecordLikesController < ApplicationController
  def create
    record = Record.find(params[:record_id])
    if current_user.like(record)
      head :created
    else
      render json: { error: "いいねの作成に失敗しました" }, status: :unprocessable_entity
    end
  end

  def destroy
    record = current_user.record_likes.find_by(record_id: params[:id]).record
    current_user.unlike(record)
  end
end
