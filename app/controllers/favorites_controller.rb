class FavoritesController < ApplicationController
before_action :authenticate_user!

  def create
    @facility = Facility.find(params[:facility_id])
    @favorite = current_user.favorites.find_or_create_by!(facility: @facility)
    @favorite_by_facility_id = { @facility.id => @favorite }

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: facility_path(@facility) }
    end
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    @facility = favorite.facility
    favorite.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: facility_path(@facility) }
    end
  end
end
