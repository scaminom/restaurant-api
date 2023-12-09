class TablesController < ApplicationController
  before_action :set_table, only: %i[show update destroy]

  def index
    @tables = Table.all

    raise ActiveRecord::RecordNotFound, 'No tables found' if @tables.empty?

    serialized_tables = @tables.map do |table|
      table_serializer(table)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, table_id: table.id }, status: :not_found
      next
    end

    render json: { tables: serialized_tables }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { table: table_serializer(@table) } if stale?(@table)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @table = Table.new(table_params)

    if @table.save
      render json: { table: table_serializer(@table) }, status: :accepted
    else
      render json: @table.errors.full_messages, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @table.update(table_params)
      render json: { table: table_serializer(@table) }
    else
      render json: { errors: @table.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @table.destroy
      render json: { message: 'Table deleted successfully' }
    else
      render json: { errors: @table.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_table
    @table = Table.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def table_params
    params.require(:table).permit(:status, :capacity)
  end

  def table_serializer(table)
    Rails.cache.fetch([cache_key(table), I18n.locale]) do
      TableSerializer.new.serialize(table)
    rescue StandardError => e
      Rails.logger.error "Error serializing table #{table.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(table)
    "tables/#{table.id}"
  end
end
