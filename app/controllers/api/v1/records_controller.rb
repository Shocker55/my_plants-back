class Api::V1::RecordsController < ApplicationController
  before_action :authenticate, except: %i[index show]

  def index
    if params[:uid] && params[:base] == "true"
      user = User.find_by(uid: params[:uid])
      if records = Record.where(user_id: user.id).where(base: true)
        render json: records
      else
        render json: { message: "レコードがありません" }
      end
    # あとでformObject等を使って処理をまとめる
    elsif params[:q] == "own" && params[:uid]
      user = User.find_by(uid: params[:uid])
      records = Record.all.where(user_id: user.id)
      render json: records, include: [record_likes: { include: :user }, user: { include: :profile }]
    else
      records = Record.all
      render json: records, include: [record_likes: { include: :user }, user: { include: :profile }]
    end
  end

  def show
    record = Record.find(params[:id])
    render json: record, include: [record_likes: { include: :user }, user: { include: :profile }]
  end

  def create
    record = current_user.records.build(record_params)
    if params[:base] == "true"
      if record.save
        head :created
      else
        render json: { message: "不正な値です", errors: record.errors.to_hash(true) }, status: 422
      end
    else
      begin
        ApplicationRecord.transaction do
          record.save!
          record.related_records.create!(related_record_id: params[:baseId].to_i)
        end
        head :created
      rescue => e
        render json: { message: "不正な値です", errors: record.errors.to_hash(true) }, status: 422
      end
    end
  end

  def destroy
    record = current_user.records.find(params[:id])
    record.destroy!
  end

  private

  def record_params
    params.permit(:title, :body, :image, :base)
  end
end
