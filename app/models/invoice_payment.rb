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
  after_save :update_associated_invoices

  # scopes ....................................................................

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  monetize :amount_cents, numericality: true
  attr_accessor :invoice_ids

  # class methods .............................................................
  class << self
  end

  # public instance methods ...................................................

  # protected instance methods ................................................

  # private instance methods ..................................................
  private

  def update_associated_invoices
    assigned_invoice_ids = invoice_ids&.map(&:to_i) || []
    current_invoice_ids = invoices.pluck(:id)
    Invoice.where(id: assigned_invoice_ids - current_invoice_ids).update_all(invoice_payment_id: id)
    Invoice.where(id: current_invoice_ids - assigned_invoice_ids).update_all(invoice_payment_id: nil)
  end
end
