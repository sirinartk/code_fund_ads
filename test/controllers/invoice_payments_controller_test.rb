require "test_helper"

class InvoicePaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invoice_payments_index_url
    assert_response :success
  end

  test "should get show" do
    get invoice_payments_show_url
    assert_response :success
  end
end
