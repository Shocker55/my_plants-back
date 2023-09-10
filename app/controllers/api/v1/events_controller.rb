class Api::V1::EventsController < ApplicationController
  before_action :authenticate, expect: %i[index show]

  def index
    events = Event.includes(event_bookmarks: { user: [:profile] }, user: [:profile]).all.order(updated_at: "DESC")
    render json: events.as_json(
      include: [event_bookmarks: { include: :user }, user: { include: :profile }]
    )
  end

  def show
    event = Event.includes(event_comments: { user: :profile }, event_bookmarks: :user, user: :profile).find(params[:id])
    render json: event.as_json(
      include: [
        event_comments: {
          include: {
            # コメントのユーザー情報を含む
            user: {
              include: :profile # ユーザープロファイルも含む
            }
          }
        },
        event_bookmarks: {
          include: :user
        },
        user: {
          include: :profile
        }
      ]
    )
  end

  def create
    if params[:date_type] == "month_only"
      # 開始日のパラメータから末日を計算
      params[:start_date] = calculate_last_day(params[:start_date])
      # 終了日のパラメータを末日を計算
      params[:end_date] = calculate_last_day(params[:end_date])
    end
    event = current_user.events.build(event_params)
    if event.save
      head :created
    else
      render json: { message: event.errors.to_hash(true) }, status: 422
    end
  end

  def update
    event = current_user.events.find(params[:id])
    if event.update(event_params)
      head :created
    else
      render json: { message: event.errors.to_hash(true) }, status: 422
    end
  end

  def destroy
    event = current_user.events.find(params[:id])
    event.destroy!
  end

  private

  def event_params
    params.permit(:title, :body, :start_date, :end_date, :date_type, :start_time, :end_time, :place, :official_url)
  end

  def calculate_last_day(date_param)
    year, month = date_param.split('-').map(&:to_i)
    last_day = Date.new(year, month, -1).day.to_s
    "#{date_param}-#{last_day}"
  end
end
