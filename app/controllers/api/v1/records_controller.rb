class Api::V1::RecordsController < ApplicationController
  before_action :authenticate, except: %i[index show related_records]

  def index
    if params[:uid] && params[:base] == "true"
      user = User.find_by(uid: params[:uid])
      if records = user.records.where(base: true)
        render json: records
      else
        render json: { message: "レコードがありません" }
      end
    elsif params[:q] == "own" && params[:uid]
      user = User.find_by(uid: params[:uid])
      records = user.records.includes(:related_records, record_likes: { user: :profile },
                                                        user: :profile).order(updated_at: "DESC")
      render json: records.as_json(
        include: [
          :related_records, {
            record_likes: { include: :user },
            user: { include: :profile }
          }
        ]
      )
    elsif params[:q] == "popular"
      records = Record.includes(
        record_likes: { user: [:profile] }, record_bookmarks: :user, user: [:profile]
      ).left_joins(:record_likes).group('records.id').order('COUNT(record_likes.id) DESC').all

      render json: records.as_json(
        include: [
          record_likes: { include: :user }, record_bookmarks: { include: :user }, user: { include: :profile }
        ]
      )
    else
      records = Record.includes(record_likes: { user: [:profile] }, record_bookmarks: :user,
                                user: [:profile]).all.order(updated_at: "DESC")
      render json: records.as_json(
        include: [record_likes: { include: :user }, record_bookmarks: { include: :user }, user: { include: :profile }]
      )
    end
  end

  def show
    record = Record.includes(record_comments: { user: :profile }, record_bookmarks: :user, record_likes: :user,
                             user: :profile).find(params[:id])
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
        record_bookmarks: {
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

  def related_records
    record = Record.find(params[:record_id])
    if record&.base == true
      related_records = Record.joins(:related_records).where(related_records: { related_record_id: params[:record_id] })

      render json: { baseRecord: record, childRecords: related_records }
    else
      base_record_id = record.related_records.first.related_record_id
      base_record = Record.find(base_record_id)
      related_records = Record.joins(:related_records).where(related_records: { related_record_id: base_record_id })

      render json: { baseRecord: base_record, childRecords: related_records }
    end
  end

  def search
    if params[:title]
      record = RecordForm.new(title: params[:title])
    elsif params[:body]
      record = RecordForm.new(body: params[:body])
    end
    records = record.search
    render json: records.as_json(
      include: [record_likes: { include: :user }, record_bookmarks: { include: :user }, user: { include: :profile }]
    )
  end

  private

  def record_params
    params.permit(:title, :body, :image, :base)
  end
end
