class SubsController < ApplicationController
    before_action :require_login, only: [:new, :create, :edit, :update]
    before_action :must_be_moderator, only: [:edit, :update]

    def must_be_moderator
        sub = Sub.find_by(id: params[:id])
        redirect_to sub_url(sub) unless current_user == sub.moderator
    end

    def index
        @subs = Sub.all
        render :index
    end

    def show
        @sub = Sub.find_by(id: params[:id])
        render :show
    end

    def new
        @sub = Sub.new
        render :new
    end

    def create
        @sub = Sub.new(sub_params)
        @sub.moderator_id = current_user.id
        if @sub.save
            render :show
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    def edit
        @sub = Sub.find_by(id: params[:id])
        render :edit
    end
    
    def update
        @sub = Sub.find_by(id: params[:id])
        if @sub.update(sub_params)
            render :show
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :edit
        end
    end

    private
    def sub_params
        params.require(:sub).permit(:title, :description)
    end
end