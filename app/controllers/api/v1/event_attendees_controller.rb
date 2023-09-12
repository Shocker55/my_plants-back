class Api::V1::EventAttendeesController < ApplicationController
  before_action :authenticate, except: %i[index]

  def index
    event = Event.find(params[:event_id])
    attendees = event.attendees
    render json: attendees, include: [:profile]
  end

  def create
    event = Event.find(params[:event_id])
    current_user.attend(event)
  end

  def destroy
    event = current_user.event_attendees.find_by(event_id: params[:id]).event
    current_user.cancel(event)
  end
end
