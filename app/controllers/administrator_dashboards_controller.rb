class AdministratorDashboardsController < ApplicationController
  before_action :authenticate_user!
  layout "admin"

  def show
    @active_campaigns = Campaign.active.premium.order(name: :asc).includes(:creative)
  end
end
