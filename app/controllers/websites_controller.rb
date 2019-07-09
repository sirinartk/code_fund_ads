class WebsitesController < ApplicationController
  layout "default"

  def index
    properties = Property.active.order(:name)
    @pagy, @properties = pagy(properties, items: 12)
  end
end
