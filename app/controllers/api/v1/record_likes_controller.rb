class Api::V1::RecordLikesController < ApplicationController
  def create
    record = Record.find(params[:record_id])
    current_user.like(record)
  end

  def destroy
    record = current_user.record_likes.find_by(record_id: params[:id]).record
    current_user.unlike(record)
  end
end
