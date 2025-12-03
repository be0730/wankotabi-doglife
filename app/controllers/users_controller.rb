class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def post_list
    @user = current_user
    @facilities = @user.facilities.order(created_at: :desc).page(params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar)
  end
end
