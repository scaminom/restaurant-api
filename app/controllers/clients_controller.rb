class ClientsController < ApplicationController
  before_action :set_client, only: %i[show update destroy]

  def index
    @clients = Client.all

    raise ActiveRecord::RecordNotFound, 'No clients found' if @clients.empty?

    serialized_clients = @clients.map do |client|
      client_serializer(client)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, client_id: client.id }, status: :not_found
      next
    end

    render json: { clients: serialized_clients }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { client: client_serializer(@client) } if stale?(@client)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      render json: { client: client_serializer(@client) }, status: :accepted
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @client.update(client_params)
      render json: { client: client_serializer(@client) }
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @client.destroy
      render json: { message: 'Client deleted successfully' }
    else
      render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_client
    @client = Client.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def client_params
    params.require(:client).permit(:id, :first_name, :last_name, :address, :email, :phone, :date, :id_type)
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
