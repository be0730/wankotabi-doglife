class FacilitiesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_facility,       only:   %i[show edit update destroy]
  before_action :authorize_owner!,   only:   %i[edit update destroy]

  # GET /facilities
  def index
    @q = Facility.ransack(params[:q])
    @facilities = @q.result.includes(:user, :prefecture).order(created_at: :desc).page(params[:page])
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
      redirect_to @facility, notice: "Facility was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /facilities/1
  def update
    if @facility.update(facility_params)
      redirect_to @facility, notice: "Facility was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /facilities/1
  def destroy
    @facility.destroy
    redirect_to facilities_path, status: :see_other, notice: "Facility was successfully destroyed."
  end

  def favorites
    @favorite_facilities = current_user.favorite_facilities.includes(:user, :prefecture).order(created_at: :desc).page(params[:page])
  end

  private

  def set_facility
    @facility = Facility.find(params[:id])
  end

  def authorize_owner!
    return if @facility.user_id == current_user.id
    redirect_to @facility, alert: "権限がありません"
  end

  def facility_params
    params.require(:facility).permit(
      :title, :category, :postal_code, :prefecture_id,
      :city, :street, :building, :latitude, :longitude,
      :overview, :phone_number, :business_hours, :closed_day,
      :homepage_url, :instagram_url, :facebook_url, :x_url, :supplement
    )
  end
end
