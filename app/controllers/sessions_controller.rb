class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        user = User.find_by_credentials(
            session_params[:username],
            session_params[:password]
        )
        if user.nil?
            flash.now[:errors] = ["Incorrect username or password."]
            render :new
        else
            login!(user)
            redirect_to subs_url
        end
    end

    def destroy
        logout!
        render :new
    end

    private
    def session_params
        params.require(:session).permit(:username, :password)
    end
end