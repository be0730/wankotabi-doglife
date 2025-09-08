class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def post_list
    @user = User.find(params[:id])
    @facilities = @user.facilities.order(created_at: :desc).page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
