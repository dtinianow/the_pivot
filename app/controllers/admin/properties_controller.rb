class Admin::PropertiesController < ApplicationController

  def new
    @property = current_user.business.properties.new
    @locations = Location.all
  end

  def create
    location = Location.find(params[:location])
    property = current_user.business.properties.new(property_params)
    property.location = location
    if property.save
      flash[:success] = "Property Created!"
      redirect_to property_path(current_user.business, property)
    else
      flash[:danger] = "Invalid Property"
      render :new
    end
  end

  def edit
    @property = current_user.business.properties.find(params[:id])
  end

  def update
    property = current_user.business.properties.find(params[:id])
    if property.update(property_params)
      flash[:success] = "Property successfully updated!"
      redirect_to property_path(property, business_name: property.business.slug)
    else
      render :edit
    end
  end

  def delete
    current_user.business.properties.delete(params[:id])
    flash[:success] = "Property Successfully Deleted!"
    redirect_to properties_path(current_user.business.slug)
  end

  private

  def property_params
    params.require(:property).permit(:title, :description, :price_per_guest, :max_occupancy, :image_path)
  end
end
