      class ApplicationController < ActionController::Base
        protect_from_forgery

        helper_method :logged_in?, :current_user

        def current_user
          @current_user ||= User.find(session[:user_id]) if session[:user_id]
        end

        def logged_in?
          !!current_user
        end

        def require_user
          unless logged_in?
            flash[:error] = "You don't have permission to do this"
            redirect_to root_path
          end
        end
      end
