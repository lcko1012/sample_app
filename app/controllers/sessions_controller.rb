class SessionsController < ApplicationController
  def new; end

  def create
    email, password, remember_me = params[:session].values_at(:email, :password,
                                                              :remember_me)
    user = User.find_by email: email.downcase

    if user&.authenticate password
      log_in user
      remember_me == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = t "sessions.new.failure_message"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
