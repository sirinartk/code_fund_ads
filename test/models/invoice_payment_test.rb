# == Schema Information
#
# Table name: invoice_payments
#
#  id                     :bigint           not null, primary key
#  user_id                :bigint           not null
#  payment_date           :date             not null
#  payment_method         :string           not null
#  amount_cents           :integer          default(0), not null
#  amount_currency        :string           default("USD"), not null
#  payment_transaction_id :string
#  paid_by                :string
#  details                :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require "test_helper"

class InvoicePaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
