class Api::V1::EventBookmarksController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    current_user.bookmark_event(event)
  end

  def destroy
    event = current_user.event_bookmarks.find_by(event_id: params[:id]).event
    current_user.unbookmark_event(event)
  end
end
