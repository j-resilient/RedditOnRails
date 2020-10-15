class PostsController < ApplicationController
    before_action :require_login, only: [:new, :edit, :create, :update]
    before_action :must_be_author, only: [:edit, :update]

    def must_be_author
        post = Post.find_by(id: params[:id])
        redirect_to post_url(post) unless current_user == post.author
    end
    
    def new
        @post = Post.new
        render :new
    end

    def create
        @post = Post.new(post_params)
        @post.author_id = current_user.id
        if @post.save
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end

    def show
        @post = Post.find_by(id: params[:id])
        @comments_hash = @post.comments_by_parent_id
        render :show
    end

    def edit
        @post = Post.find_by(id: params[:id])
        render :edit
    end
    
    def update
        @post = Post.find_by(id: params[:id])
        if @post.update(post_params)
            redirect_to post_url(@post)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :edit
        end
    end

    def upvote
        vote(Vote.new(votable_id: params[:id], value: 1, votable_type: "Post"))
    end
    
    def downvote
        vote(Vote.new(votable_id: params[:id], value: -1, votable_type: "Post"))
    end

    private
    def post_params
        params.require(:post).permit(:title, :url, :content, sub_ids: [])
    end

    def vote(vote)
        vote.save
        flash.now[:errors] = vote.errors.full_messages if vote.errors
        redirect_to post_url(vote.votable_id)
    end
end