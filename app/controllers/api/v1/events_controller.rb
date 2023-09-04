class Api::V1::EventsController < ApplicationController
  before_action :authenticate, expect: %i[index show]

  def index
    events = Event.all.order(updated_at: "DESC")
    render json: events
  end

  def show
    event = Event.find(params[:id])
    render json: event
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

  def edit; end

  def destroy; end

  private

  def event_params
    params.permit(:title, :body, :start_date, :end_date, :date_type, :start_time, :end_time, :place, :official_url)
  end

  def calculate_last_day(date_param)
    year, month = date_param.split('-').map(&:to_i)
    last_day = Date.new(year, month, -1).day.to_s
    `#{date_param}-#{last_day}`
  end
end