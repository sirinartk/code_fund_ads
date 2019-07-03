class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_administrator!, except: [:index]
  before_action :set_user
  before_action :set_invoice, except: [:index, :new, :create]

  def index
    if authorized_user.can_admin_system?
      invoices = @user.invoices.order(invoice_date: :desc)
    else
      invoices = current_user.invoices.order(invoice_date: :desc)
    end
    @pagy, @invoices = pagy(invoices)

    render "/invoices/for_user/index" if authorized_user.can_admin_system? && true_user == current_user
  end

  def new
    @invoice = Invoice.new(user: @user)
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to user_invoices_path(@user), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: [@user, @invoice] }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
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

  def set_invoice
    @invoice = @user.invoices.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:ad_revenue, :ad_spend, :bonus_referral, :bonus_direct)
  end
end
