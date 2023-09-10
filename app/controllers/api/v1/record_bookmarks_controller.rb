class Api::V1::RecordBookmarksController < ApplicationController
  def create
    record = Record.find(params[:record_id])
    current_user.bookmark_record(record)
  end

  def destroy
    record = current_user.record_bookmarks.find_by(record_id: params[:id]).record
    current_user.unbookmark_record(record)
  end
end
