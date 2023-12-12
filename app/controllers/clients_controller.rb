class ClientsController < ApplicationController
  before_action :set_client, only: %i[show update destroy]

  def index
    clients = Client.all

    render json: Panko::ArraySerializer.new(
      clients, each_serializer: ClientSerializer
    ).to_json
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(*Client::WHITELISTED_ATTRIBUTES)
  end

  def client_serializer(client)
    Rails.cache.fetch([cache_key(client), I18n.locale]) do
      ClientSerializer.new.serialize(client)
    rescue StandardError => e
      Rails.logger.error "Error serializing client #{client.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(client)
    "clients/#{client.id}"
  end
end
