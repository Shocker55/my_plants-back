class Api::V1::RecordsController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    if params[:uid] && params[:base] == "true"
      user = User.find_by(uid: params[:uid])
      if records = Record.where(user_id: user.id).where(base: true)
        render json: records
      else
        render json: {message: "レコードがありません"}
      end
    else
      records = Record.all
      render json: records
    end
  end

  def show
    record = Record.find(params[:id])
    render json: record
  end

  def create
    record = current_user.records.build(record_params)
    if record.save
      head :created
    else
      render json: {message: "不正な値です", errors: record.errors.to_hash(true)}, status: 422
    end
  end

  def record_params
    params.require(:record).permit(:title, :body, :image, :base)
  end
end
