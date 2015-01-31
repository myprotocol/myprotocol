class CoachesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_coach, only: [:show, :edit, :update]

  def index
    @coaches = Coach.gcoded
  end

  def search
    @coaches = Coach.closest_coaches(params[:zipcode]) if params[:zipcode].present?
    @hash = Gmaps4rails.build_markers(@coaches) do |coach, marker|
      if coach and coach.latitude and coach.longitude
        marker.lat coach.latitude
        marker.lng coach.longitude
        marker.infowindow coach.name
      end
    end
    render json: @hash.to_json
  end

  def show
  end

  def new
    if current_user.coach.nil?
      @coach = Coach.new(user: current_user)
    else
      redirect_to action: 'edit', id: current_user.coach.id
    end
  end

  def edit
    auth_redirect unless current_user.admin? or current_user.coach == @coach
  end

  def create
    auth_redirect unless current_user.coach.nil?
    @coach = Coach.new(coach_params)

    @coach.user = current_user

    if @coach.save
      redirect_to @coach, notice: 'Coach was successfully created.'
    else
      render :new
    end
  end

  def update
    auth_redirect unless current_user.admin? or current_user.coach == @coach
    if @coach.update(coach_params)
      redirect_to @coach, notice: 'Coach was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    current_user.coach.destroy
    redirect_to coaches_url, notice: 'Coach was successfully destroyed.'
  end

private
  def set_coach
    @coach = Coach.find(params[:id])
  end

  def auth_redirect
    redirect_to controller: 'home', action: 'index'
  end

  def coach_params
    params.require(:coach).permit(:name, :business, :street, :city, :state, :zip, :phone_number, :certifications, :bio, :quote, :quoter, :shirt_size, :image)
  end
end
