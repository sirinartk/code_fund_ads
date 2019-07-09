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

class Invoice < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  belongs_to :user
  belongs_to :invoice_payment, optional: true

  # validations ...............................................................
  validates :invoice_date, presence: true

  # callbacks .................................................................

  # scopes ....................................................................
  scope :for_date, ->(date) { where(invoice_date: Date.coerce(date)) }
  scope :without_invoice_payments, -> { where(invoice_payment_id: nil) }
  scope :with_transactions, -> {
    where.not(ad_revenue_cents: 0).or(
      Invoice.where(ad_spend_cents: 0).or(
        Invoice.where(bonus_referral_cents: 0).or(
          Invoice.where(bonus_direct_cents: 0)
        )
      )
    )
  }

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  monetize :ad_revenue_cents, numericality: true
  monetize :ad_spend_cents, numericality: true
  monetize :bonus_referral_cents, numericality: true
  monetize :bonus_direct_cents, numericality: true

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................

  def total_amount
    Monetize.parse(ad_revenue - ad_spend + bonus_referral + bonus_direct)
  end

  def paid_amount
    Monetize.parse(invoice_payment&.amount || 0)
  end

  def owed_amount
    total_amount - paid_amount
  end

  # protected instance methods ................................................

  # private instance methods ..................................................
end
