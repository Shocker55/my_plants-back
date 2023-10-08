class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: %i[index show likes]

  def index
    users = User.includes(:profile).where.not(profiles: { id: nil }).order(id: :desc).page(params[:page]).per(8)
    render json: users, include: [:profile]
  end

  def show
    user = User.find_by(uid: params[:id])
    render json: user, include: [:profile]
  end

  def likes
    # ログインしているユーザー限定ではなく、全ユーザーにいいねした記録を表示したいためparamsからユーザーを取得
    user = User.find_by(uid: params[:id])
    like_records = user.like_records.includes(:user, :tags)
    render json: like_records, include: [record_likes: { include: :user }, user: { include: :profile }, tags: {}]
  end

  def record_bookmarks
    # ログインしているユーザーのブックマークを表示するためcurrent_userを使う
    bookmark_records = current_user.bookmark_records.includes(:record_likes, :record_bookmarks,
                                                              user: :profile, tags: {}).order('record_bookmarks.created_at DESC')
    render json: bookmark_records.as_json(
      include: [record_likes: { include: :user }, record_bookmarks: { include: :user }, user: { include: :profile }, tags: {}]
    )
  end

  def event_bookmarks
    # ログインしているユーザーのブックマークを表示するためcurrent_userを使う
    bookmark_events = current_user.bookmark_events.includes(:event_bookmarks).order('event_bookmarks.created_at DESC')
    render json: bookmark_events.as_json(
      include: [event_bookmarks: { include: :user }, user: { include: :profile }]
    )
  end

  def attend
    user = User.find_by(uid: params[:id])
    attend_events = if params[:page]
                      user.attend_events.where("end_date >= ?", Date.today).page(params[:page]).per(8)
                    else
                      user.attend_events.where("end_date >= ?", Date.today)
                    end
    render json: attend_events.as_json(
      include: [event_bookmarks: { include: :user }, user: { include: :profile }]
    )
  end

  def widget
    last_record_date = current_user.records.last&.updated_at
    record_count = current_user.records.count
    full_date_upcoming_attend_event = current_user.attend_events
                                                  .where("date_type = ?", 0)
                                                  .where("end_date >= ?", Date.today)
                                                  .order(start_date: :asc)
                                                  .first

    month_only_upcoming_attend_event = current_user.attend_events
                                                   .where("date_type = ?", 1)
                                                   .where("end_date >= ?", Date.today)
                                                   .order(start_date: :asc)
                                                   .first

    upcoming_event = if full_date_upcoming_attend_event && month_only_upcoming_attend_event &&
                        (full_date_upcoming_attend_event.start_date.month - month_only_upcoming_attend_event.start_date.month) >= 1
                       { id: month_only_upcoming_attend_event.id, title: month_only_upcoming_attend_event.title }
                     elsif full_date_upcoming_attend_event && month_only_upcoming_attend_event &&
                           (full_date_upcoming_attend_event.start_date.month - month_only_upcoming_attend_event.start_date.month) < 1
                       { id: full_date_upcoming_attend_event.id, title: full_date_upcoming_attend_event.title }
                     elsif full_date_upcoming_attend_event && !month_only_upcoming_attend_event
                       { id: full_date_upcoming_attend_event.id, title: full_date_upcoming_attend_event.title }
                     elsif !full_date_upcoming_attend_event && month_only_upcoming_attend_event
                       { id: month_only_upcoming_attend_event.id, title: month_only_upcoming_attend_event.title }
                     end

    render json: {
      last_record_date:,
      record_count:,
      upcoming_event:
    }
  end
end
