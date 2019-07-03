class SearchController < ApplicationController
  before_action :authenticate_user!

  def show
    return handle_redirect if params[:sgid].present?

    q = params[:q].strip.downcase
    if authorized_user.can_admin_system?
      @results = {
        users: User.search_name(q).or(User.search_email(q)).limit(5),
        properties: Property.search_name(q).limit(5),
        campaigns: Campaign.search_name(q).limit(5),
        organizations: Organization.search_name(q).limit(5),
      }
    else
      @results = {
        users: [],
        organizations: [],
        properties: current_user.properties.search_name(q).limit(5),
        campaigns: current_user.campaigns.search_name(q).limit(5)
      }
    end
    render layout: false
  end

  def handle_redirect
    obj = GlobalID.parse(params[:sgid]).find
    redirect_to obj
  end
end
