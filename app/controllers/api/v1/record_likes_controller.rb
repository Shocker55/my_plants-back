class Api::V1::RecordLikesController < ApplicationController
  def create
    record = Record.find(params[:record_id])
    current_user.like(record)
  end

  def destroy
    record = current_user.record_likes.find(params[:id].to_i).record
    current_user.unlike(record)
  end
end
