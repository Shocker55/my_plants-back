class Api::V1::UsersController < ApplicationController
  before_action :authenticate, except: %i[index show likes]

  def index
    users = User.all
    render json: users, include: [:profile]
  end

  def show
    user = User.find_by(uid: params[:id])
    render json: user, include: [:profile]
  end

  def likes
    # ログインしているユーザー限定ではなく、全ユーザーにいいねした記録を表示したいためparamsからユーザーを取得
    user = User.find_by(uid: params[:id])
    like_records = user.like_records
    render json: like_records, include: [record_likes: { include: :user }, user: { include: :profile }]
  end

  def record_bookmarks
    # ログインしているユーザーのブックマークを表示するためcurrent_userを使う
    bookmark_records = current_user.bookmark_records.includes(:record_likes, :record_bookmarks,
                                                              user: :profile).order('record_bookmarks.created_at DESC')
    render json: bookmark_records.as_json(
      include: [record_likes: { include: :user }, record_bookmarks: { include: :user }, user: { include: :profile }]
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
    attend_events = user.attend_events.where("end_date >= ?", Date.today)
    render json: attend_events.as_json(
      include: [event_bookmarks: { include: :user }, user: { include: :profile }]
    )
  end
end
