# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::WHITELISTED_ATTRIBUTES)
  end

  def respond_with(resource, _options = {})
    puts resource.inspect
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource }
      }
    else
      render json: {
        status: { message: 'User could not be created successfully', errors: resource.errors.full_messages,
                  status: :unprocessable_entity }
      }
    end
  end
end
