# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_facility
  before_action :set_comment, only: :destroy
  before_action :authorize_comment_owner!, only: :destroy

  def create
    @comment = @facility.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      redirect_to facility_path(@facility), notice: "コメントを投稿しました。"
    else
      # 失敗時は施設詳細をエラー付きで再表示
      @comments = @facility.comments.includes(:user).order(created_at: :desc)
      render "facilities/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to facility_path(@facility), notice: "コメントを削除しました。", status: :see_other
  end

  private

  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def set_comment
    @comment = @facility.comments.find(params[:id])
  end

  def authorize_comment_owner!
    return if @comment.user_id == current_user.id
    redirect_to facility_path(@facility), alert: "権限がありません"
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
