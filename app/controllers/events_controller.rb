class EventsController < ApplicationController
  before_action :set_event, only: %i[show update destroy]

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
