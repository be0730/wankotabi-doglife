class FacilitiesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_facility,       only:   %i[show edit update destroy destroy_image]
  before_action :set_tags,           only:   %i[index new edit create update]
  before_action :authorize_owner!,   only:   %i[edit update destroy destroy_image]

  # GET /facilities
  def index
    @q = Facility.ransack(params[:q])
    @q_params = params.fetch(:q, {}).permit(
      :category_eq,
      :prefecture_id_eq,
      :title_or_overview_or_city_or_street_cont,
      prefecture_id_in: [],
      tags_id_in: []
    )
    @facilities = @q.result(distinct: true)
                    .includes(:user, :prefecture, :tags)
                    .order(created_at: :desc)
                    .page(params[:page]).per(6)
  end

  # GET /facilities/1
  def show
    @facility = Facility.find(params[:id])
    @comment  = Comment.new
    @comments = @facility.comments.includes(:user).order(created_at: :desc)
  end

  # GET /facilities/new
  def new
    @facility = current_user.facilities.new
  end

  def confirm
  if params[:id].present?          # 編集の確認
    @facility = current_user.facilities.find(params[:id])
    @facility.assign_attributes(facility_params)
    back_template = :edit
  else                              # 新規の確認
    @facility = current_user.facilities.new(facility_params)
    back_template = :new
  end

  return render(back_template) if params[:back]

  if @facility.valid?
    render :confirm
  else
    flash.now[:danger] = "入力に誤りがあります。"
    render back_template, status: :unprocessable_entity
  end
end


  # GET /facilities/1/edit
  def edit; end

  # POST /facilities
  def create
    @facility = current_user.facilities.new(facility_params)
    if params[:back]
      render :new
    elsif @facility.save
      redirect_to @facility, success: "施設を投稿しました。"
    else
      flash.now[:danger] = "施設の投稿に失敗しました。"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /facilities/1
  def update
    if @facility.update(facility_params)
      redirect_to @facility, success: "施設を更新しました。"
    else
      flash.now[:danger] = "施設の更新に失敗しました。"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /facilities/1
  def destroy
    @facility.destroy
    redirect_to facilities_path, status: :see_other, success: "施設を削除しました。"
  end

  def favorites
    @favorite_facilities = current_user.favorite_facilities.includes(:user, :prefecture).order(created_at: :desc).page(params[:page])
  end

  def destroy_image
    # image.signed_id を受け取って、その blob を探す
    blob = ActiveStorage::Blob.find_signed(params[:signed_id])

    # 該当添付を特定して purge（添付解除+必要ならblobも削除）
    attachment = @facility.images.attachments.find_by!(blob_id: blob.id)
    attachment.purge

    redirect_back fallback_location: edit_facility_path(@facility), notice: "画像を削除しました。"
  end

  private

  def set_facility
    if params[:facility_id].present?
      @facility = Facility.find(params[:facility_id])
    else
      @facility = Facility.find(params[:id])
    end
  end

  def set_tags
    @tags = Tag.order(:id)
  end

  def authorize_owner!
    return if @facility.user_id == current_user.id
    redirect_to @facility, alert: "権限がありません"
  end

  def facility_params
    params.require(:facility).permit(
      :title, :category, :postal_code, :prefecture_id,
      :full_address, :city, :street, :building, :latitude, :longitude,
      :overview, :phone_number, :business_hours, :closed_day,
      :homepage_url, :instagram_url, :facebook_url, :x_url, :supplement,
      images: [], tag_ids: []
    )
  end
end
