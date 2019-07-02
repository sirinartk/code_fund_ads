class CreateInvoicePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_payments do |t|
      t.bigint :user_id, null: false
      t.date :payment_date, null: false
      t.string :payment_method, null: false
      t.monetize :amount, default: 0.0
      t.string :payment_transaction_id
      t.string :paid_by
      t.text :details

      t.index :user_id

      t.timestamps
    end
  end
end
