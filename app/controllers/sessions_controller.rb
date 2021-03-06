class SessionsController < ApplicationController
  layout "forms", only: [:new, :create]
  skip_before_action :authorized_user
  def omniauth
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(uid: auth['uid'], provider: auth['provider']) do |u|
      u.first_name = auth['info']['first_name']
      u.last_name = auth['info']['last_name']
      u.email = auth['info']['email']
      u.password = SecureRandom.hex(16)
    end

    @user.password = SecureRandom.hex(16) if @user

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      router('new', :message, @user.errors.full_messages.join(", "))
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      router('new', :message,'incorrect email/password')
    end
  end


  def destroy
    session.delete("user_id")
    redirect_to root_path
  end
end
