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

class InvoicePayment < ApplicationRecord
  # extends ...................................................................
  # includes ..................................................................

  # relationships .............................................................
  has_many :invoices
  belongs_to :user

  # validations ...............................................................
  validates :payment_date, presence: true
  validates :payment_method, presence: true

  # callbacks .................................................................
  # scopes ....................................................................

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  monetize :amount_cents, numericality: true

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................

  # protected instance methods ................................................

  # private instance methods ..................................................
end
