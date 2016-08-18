class Api::V1::PropertiesController < ApplicationController
  respond_to :json
  # skip_before_action :require_user, :require_admin

  def index
    @properties = find_properties
    respond_with @properties
  end

  private

  def find_properties
    business = Business.find_by(slug: params[:business_name])
    business.properties.all
  end
end