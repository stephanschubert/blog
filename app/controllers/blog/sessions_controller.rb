module Blog
  class SessionsController < ApplicationController
    #include ActionController::Messages
    #include ActionController::Memorize

    helper_method :logged_in?

    def logged_in?
      !!session[:user_id]
    end

    def go_back
      destination = params[:back_url] || :back
      redirect_to destination
    end
  end

end
