class SessionsController < ApplicationController
  def login_form
  end
  def login
    auth_hash = request.env['omniauth.auth']
    if auth_hash['uid']
      user = User.find_by(provider: params[:provider], uid: auth_hash['uid'])
      if user.nil?
        # user has not logged in before
        # create a new instance of user
        user = User.from_auth_hash(params[:provider], auth_hash)

        #could use save and flash method here
        if user.save
          flash[:status] = :success
          flash[:message] = "Successfully created new user #{user.name}"
        else
          flash[:status] = :failure
        end

      else
        flash[:status] = :success
        flash[:message] = "Successfully logged in as returning user #{user.name}"
      end
      session[:user_id] = user.id
    else
      flash[:status] = :failure
      flash[:message] = "could not create user"
    end
    redirect_to root_path
  end


  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end
end
