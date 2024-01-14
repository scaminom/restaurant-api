class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show update destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    invoices = Invoice.all
    render json: Panko::ArraySerializer.new(
      invoices, each_serializer: InvoiceSerializer
    ).to_json
  end

  def show
    render json: { invoice: invoice_serializer(@invoice) }
  end

  def create
    invoice_creator = InvoiceCreator.new(invoice_params)
    @invoice = invoice_creator.call

    if @invoice.save
      render json: { invoice: invoice_serializer(@invoice) }, status: :accepted
    else
      render json: @invoice.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @invoice.update(invoice_params)
      render json: { invoice: invoice_serializer(@invoice) }
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @invoice.destroy
      render json: { message: 'invoice deleted successfully' }
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(*Invoice::WHITELISTED_ATTRIBUTES)
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
