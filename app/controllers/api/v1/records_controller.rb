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
      records = user.records.includes(record_likes: { user: :profile }, user: :profile)
      render json: records.as_json(include: [record_likes: { include: :user }, user: { include: :profile }])
    else

      records = Record.includes(record_likes: { user: [:profile] }, user: [:profile]).all
      render json: records.as_json(
        include: [record_likes: { include: :user }, user: { include: :profile }]
      )
    end
  end

  def show
    record = Record.includes(record_comments: { user: :profile }, record_likes: :user, user: :profile).find(params[:id])
    render json: record.as_json(
      include: [
        # レコードのコメントを含む
        record_comments: {
          include: {
            # コメントのユーザー情報を含む
            user: {
              include: :profile # ユーザープロファイルも含む
            }
          }
        },
        record_likes: {
          include: :user
        },
        user: {
          include: :profile
        }
      ]
    )
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
