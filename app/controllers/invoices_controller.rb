class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show update destroy]

  def index
    @invoices = Invoice.all

    raise ActiveRecord::RecordNotFound, 'No invoices found' if @invoices.empty?

    serialized_invoices = @invoices.map do |invoice|
      invoice_serializer(invoice)
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message, invoice_id: invoice.id }, status: :not_found
      next
    end

    render json: { invoices: serialized_invoices }
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    render json: { invoice: invoice_serializer(@invoice) } if stale?(@invoice)
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      render json: { invoice: invoice_serializer(@invoice) }, status: :accepted
    else
      render json: @invoice.errors.full_messages, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def update
    if @invoice.update(invoice_params)
      render json: { invoice: invoice_serializer(@invoice) }
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def destroy
    if @invoice.destroy
      render json: { message: 'invoice deleted successfully' }
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def invoice_params
    params.require(:invoice).permit(:order_number, :payment_method, :client_id)
  end

  def invoice_serializer(invoice)
    Rails.cache.fetch([cache_key(invoice), I18n.locale]) do
      InvoiceSerializer.new.serialize(invoice)
    rescue StandardError => e
      Rails.logger.error "Error serializing invoice #{invoice.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(invoice)
    "invoices/#{invoice.id}"
  end
end
