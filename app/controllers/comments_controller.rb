# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facility, only: :create
  before_action :set_own_comment!, only: :destroy

  def create
    @comment = @facility.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to facility_path(@facility), success: "コメントを投稿しました。"
    else
      flash.now[:danger] = "コメントの投稿に失敗しました。"
      redirect_to facility_path(@facility), status: :unprocessable_entity
    end
  end

  def destroy
    facility = @comment.facility
    @comment.destroy!
    redirect_to facility_path(facility), status: :see_other, success: "コメントを削除しました。"
  end

  private

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def set_comment
    @comment  = Comment.find(params[:id])
  end

  def set_own_comment!
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
