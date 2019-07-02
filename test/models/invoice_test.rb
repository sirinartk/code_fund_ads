# == Schema Information
#
# Table name: invoices
#
#  id                      :bigint           not null, primary key
#  user_id                 :bigint
#  invoice_payment_id      :bigint
#  invoice_date            :date
#  ad_revenue_cents        :integer          default(0), not null
#  ad_revenue_currency     :string           default("USD"), not null
#  ad_spend_cents          :integer          default(0), not null
#  ad_spend_currency       :string           default("USD"), not null
#  bonus_referral_cents    :integer          default(0), not null
#  bonus_referral_currency :string           default("USD"), not null
#  bonus_direct_cents      :integer          default(0), not null
#  bonus_direct_currency   :string           default("USD"), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require "test_helper"

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
