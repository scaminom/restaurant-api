class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]

  def index
    @events = Event.all

    raise ActiveRecord::RecordNotFound, 'No events found' if @events.empty?

    serialized_events = @events.map do |event|
      event_serializer(event)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, event_id: event.id }, status: :not_found
      next
    end

    render json: { events: serialized_events }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { event: event_serializer(@event) } if stale?(@event)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: { event: event_serializer(@event) }, status: :accepted
    else
      render json: @event.errors.full_messages, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @event.update(event_params)
      render json: { event: event_serializer(@event) }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @event.destroy
      render json: { message: 'Event deleted successfully' }
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def event_params
    params.require(:event).permit(:description, :event_type, :user_id, :order_number)
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
