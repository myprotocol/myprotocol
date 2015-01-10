class GymsController < ApplicationController
  before_action :set_gym, only: [:show, :edit]

  def index
    @gyms = Gym.all
  end

  def show
    auth_redirect unless current_user.admin? or current_user.profile == @profile
  end

  def new
    if current_user.gym.nil?
      @gym = Gym.new
    else
      redirect_to action: 'edit', id: current_user.gym.id
    end
  end

  def edit
    auth_redirect unless current_user.admin? or current_user.gym == @gym
  end

  def create
    auth_redirect unless current_user.gym.nil?
    @gym = Gym.new(gym_params)

    @gym.user = current_user

    if @gym.save
      redirect_to @gym, notice: 'Gym was successfully created.'
    else
      render :new
    end
  end

  def update
    auth_redirect unless current_user.admin? or current_user.gym == @gym
    if current_user.gym.update(gym_params)
      redirect_to current_user.gym, notice: 'Gym was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    current_user.gym.destroy
    redirect_to gyms_url, notice: 'Gym was successfully destroyed.'
  end

  private
    def set_gym
      @gym = Gym.find(params[:id])
    end

    def auth_redirect
      redirect_to controller: 'home', action: 'index'
    end

    def gym_params
      params.require(:gym).permit(:name, :street, :city, :state, :zip, :image)
    end
end
