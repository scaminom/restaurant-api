class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    events = Event.all
    render json: Panko::ArraySerializer.new(
      events, each_serializer: EventSerializer
    ).to_json
  end

  def show
    render json: { event: event_serializer(@event) }
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: { event: event_serializer(@event) }, status: :accepted
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      render json: { event: event_serializer(@event) }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @event.destroy
      render json: { message: 'Event deleted successfully' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(*Event::WHITELISTED_ATTRIBUTES)
  end

  def event_serializer(event)
    Rails.cache.fetch([cache_key(event), I18n.locale]) do
      EventSerializer.new.serialize(event)
    rescue StandardError => e
      Rails.logger.error "Error serializing event #{event.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(event)
    "events/#{event.id}"
  end
end
