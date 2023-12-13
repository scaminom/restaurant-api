class UsersController < ApplicationController
  before_action :set_user, only: %i[show destroy]

  def index
    users = User.all

    render json: Panko::ArraySerializer.new(
      users, each_serializer: UserSerializer
    ).to_json
  end

  def show
    render json: { user: user_serializer(@user) }
  end

  def create
    puts params.inspect
    @user = User.new(user_params)

    if @user.save
      render json: { user: user_serializer(@user) }, status: :accepted
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { user: user_serializer(@user) }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: { message: 'user deleted successfully' }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(*User::WHITELISTED_ATTRIBUTES)
  end

  def user_serializer(user)
    Rails.cache.fetch([cache_key(user), I18n.locale]) do
      UserSerializer.new.serialize(user)
    rescue StandardError => e
      Rails.logger.error "Error serializing user #{user.id}: #{e.message}"
      {}.as_json
    end
  end

  def cache_key(user)
    "users/#{user.id}"
  end
end
