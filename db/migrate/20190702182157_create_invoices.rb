class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.bigint :user_id
      t.bigint :invoice_payment_id
      t.date :invoice_date
      t.monetize :ad_revenue, null: false, default: 0.0
      t.monetize :ad_spend, null: false, default: 0.0
      t.monetize :bonus_referral, null: false, default: 0.0
      t.monetize :bonus_direct, null: false, default: 0.0

      t.index :user_id
      t.index :invoice_date
      t.index :invoice_payment_id

      t.timestamps
    end
  end
end
