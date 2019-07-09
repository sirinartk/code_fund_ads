class InvoicePaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_administrator!, except: [:index, :show]
  before_action :set_user
  before_action :set_invoice_payment, except: [:index, :new, :create]

  def index
    invoice_payments = if authorized_user.can_admin_system?
      @user.invoice_payments.order(payment_date: :desc)
    else
      current_user.invoice_payments.order(payment_date: :desc)
    end
    @pagy, @invoice_payments = pagy(invoice_payments)

    render "/invoice_payments/for_user/index" if authorized_user.can_admin_system? && true_user == current_user
  end

  def new
    @invoice_payment = InvoicePayment.new(user: @user)
  end

  def create
    @invoice_payment = InvoicePayment.new(invoice_payment_params)

    respond_to do |format|
      if @invoice_payment.save
        format.html { redirect_to user_invoice_payments_path(@user), notice: "Invoice payment was successfully created." }
        format.json { render :show, status: :created, location: [@user, @invoice_payment] }
      else
        format.html { render :new }
        format.json { render json: @invoice_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice_payment.update(invoice_payment_params)
        format.html { redirect_to user_invoice_payments_path(@user), notice: "Invoice payment was successfully updated." }
        format.json { render :show, status: :ok, location: [@user, @invoice_payment] }
      else
        format.html { render :edit }
        format.json { render json: @invoice_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = if authorized_user.can_admin_system?
      User.find(params[:user_id])
    else
      current_user
    end
  end

  def set_invoice_payment
    @invoice_payment = @user.invoice_payments.find(params[:id])
  end

  def invoice_payment_params
    params.require(:invoice_payment)
      .permit(
        :user_id,
        :payment_method,
        :amount,
        :payment_transaction_id,
        :paid_by,
        :details,
        invoice_ids: [] # virtual attribute used in after save callback
      ).tap do |whitelisted|
        whitelisted[:payment_date] = Date.strptime(params[:invoice_payment][:payment_date], Date::DATE_FORMATS["mm/dd/yyyy"])
      end
  end
end
