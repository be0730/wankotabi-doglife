class FavoritesController < ApplicationController
before_action :authenticate_user!

  def create
    @facility = Facility.find(params[:facility_id])
    current_user.favorites.find_or_create_by!(facility: @facility)
    respond_to do |format|
      format.turbo_stream
      format.html { render :create, formats: :turbo_stream }
    end
  end

  def destroy
    favorite = current_user.favorites.find(params[:id])
    @facility = favorite.facility
    favorite.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { render :destroy, formats: :turbo_stream }
    end
  end
end
