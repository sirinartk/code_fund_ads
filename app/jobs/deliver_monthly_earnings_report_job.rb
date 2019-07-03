class DeliverMonthlyEarningsReportJob < ApplicationJob
  queue_as :default

  def perform(user_id, date)
    date = Date.coerce(date)
    user = User.find(user_id)
    invoice = user.invoices.for_date(date).first
    total_unpaid_earnings = user.invoices.includes(:invoice_payment).sum(&:owed)
    return unless invoice

    
  end
end
