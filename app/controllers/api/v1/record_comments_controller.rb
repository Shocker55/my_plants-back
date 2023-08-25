class Api::V1::RecordCommentsController < ApplicationController
  def create
    comment = current_user.record_comments.build(record_id: params[:record_id].to_i, comment: params[:comment])
    if comment.save
      head :created
    else
      render json: { errors: comment.errors.to_hash(true) }, status: 422
    end
  end

  def destroy
    comment = current_user.record_comments.find(params[:id])
    comment.destroy!
  end
end
