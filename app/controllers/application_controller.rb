class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from ActionController::RoutingError, with: :not_found_method

  private

  def not_found_method
    route_info = "No route matches [#{request.method}] \"#{request.original_fullpath}\""
    render json: { error: route_info }.to_json, status: :not_found, layout: false
  end

  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
