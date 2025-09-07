class FavoriteController < ApplicationController
  def create
    @facility = Facility.find(params[:facility_id])
    current_user.favorites(@facility)
    end
  end

  def destroy
    @facility = current_user.favorites.find(params[:facility_id]).facility
    current_user.unfavorite(@facility)
    if favorite&.destroy
      redirect_to facility_path(@facility), notice: "施設をお気に入りから削除しました。"
    else
      redirect_to facility_path(@facility), alert: "施設のお気に入り削除に失敗しました。"
    end
  end
end
