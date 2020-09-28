class PostsController < ApplicationController
    def new
        render :new
    end

    def create
        post = Post.new(post_params)
        post.author_id = current_user.id
        if post.save
            render json: post
        else
            flash.now[:errors] = post.errors.full_messages
            render :new
        end
    end

    private
    def post_params
        params.require(:post).permit(:title, :url, :content, :sub_id)
    end
end