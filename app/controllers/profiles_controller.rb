class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def index
    auth_redirect unless current_user.admin?
    @profiles = Profile.all
  end

  def show
    auth_redirect unless current_user.admin? or current_user.profile == @profile
  end

  def new
    if current_user.profile.nil?
      @profile = Profile.new(user: current_user)
    else
      redirect_to action: 'edit', id: current_user.profile.id
    end
  end

  def edit
    auth_redirect unless current_user.admin? or current_user.profile == @profile
  end

  def create
    auth_redirect unless current_user.profile.nil?
    @profile = Profile.new(profile_params)

    @profile.user = current_user

    if @profile.save
      redirect_to controller: 'home', action: 'index', notice: 'Profile was successfully updated.'
    else
      render :new
    end
  end

  def update
    auth_redirect unless current_user.admin? or current_user.profile == @profile
    if @profile.update(profile_params)
      redirect_to @profile, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    auth_redirect unless current_user.admin? or current_user.profile == @profile
    @profile.destroy
    redirect_to profiles_url, notice: 'Profile was successfully destroyed.'
  end

private
  def set_profile
    @profile = Profile.find(params[:id])
  end

  def auth_redirect
    redirect_to controller: 'home', action: 'index'
  end

  def profile_params
    params.require(:profile).permit(:zipcode, :gender, :body_type, :birthday, :height, :weight, :waist, :blood_type, :veggies_per_day, :activity_level, {goal_ids: [], restriction_ids: []})
  end
end
