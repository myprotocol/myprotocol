class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    if params[:coach]
      new_coach_path
    else
      new_profile_path
    end
  end
end
