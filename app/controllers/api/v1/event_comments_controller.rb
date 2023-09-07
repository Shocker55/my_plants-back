class Api::V1::EventCommentsController < ApplicationController
  def create
    comment = current_user.event_comments.build(event_id: params[:event_id].to_i, comment: params[:comment])
    if comment.save
      head :created
    else
      render json: { errors: comment.errors.to_hash(true) }, status: 422
    end
  end

  def destroy
    comment = current_user.event_comments.find(params[:id])
    comment.destroy!
  end
end
