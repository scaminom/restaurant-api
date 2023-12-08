require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @invoice = invoices(:one)
  end

  test "should get index" do
    get invoices_url, as: :json
    assert_response :success
  end

  test "should create invoice" do
    assert_difference("Invoice.count") do
      post invoices_url, params: { invoice: { client_id: @invoice.client_id, invoice_number: @invoice.invoice_number, order: @invoice.order, payment_method: @invoice.payment_method } }, as: :json
    end

    assert_response :created
  end

  test "should show invoice" do
    get invoice_url(@invoice), as: :json
    assert_response :success
  end

  test "should update invoice" do
    patch invoice_url(@invoice), params: { invoice: { client_id: @invoice.client_id, invoice_number: @invoice.invoice_number, order: @invoice.order, payment_method: @invoice.payment_method } }, as: :json
    assert_response :success
  end

  test "should destroy invoice" do
    assert_difference("Invoice.count", -1) do
      delete invoice_url(@invoice), as: :json
    end

    assert_response :no_content
  end
end
