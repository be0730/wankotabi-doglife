class FacilitiesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_facility,       only:   %i[show edit update destroy]
  before_action :authorize_owner!,   only:   %i[edit update destroy]

  # GET /facilities
  def index
    @facilities = Facility.order(created_at: :desc).includes(:user)
  end

  # GET /facilities/1
  def show; end

  # GET /facilities/new
  def new
    @facility = current_user.facilities.new
  end

  # GET /facilities/1/edit
  def edit; end

  # POST /facilities
  def create
    @facility = current_user.facilities.new(facility_params)
    if @facility.save
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
