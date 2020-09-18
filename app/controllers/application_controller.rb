class ApplicationController < ActionController::Base
    helper_method :current_user, :login!, :logout!

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(username, password)
        return if @current_user
        user = User.find_by_credentials(username, password)
        if user.nil?
            flash.now[:errors] = ["Incorrect username or password."]
            return nil
        end
        session[:session_token] = user.session_token
        @current_user = user
    end

    def logout!
        @current_user.reset_session_token
        @current_user = nil
        session[:session_token] = nil
    end
end
