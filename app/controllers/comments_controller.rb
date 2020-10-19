class CommentsController < ApplicationController
    before_action :require_login, only: [:create]
    def new
        @post_id = params[:post_id]
        render :new
    end

    def create
        comment = Comment.new(comment_params)
        comment.author_id = current_user.id
        # if child comment, set post_id
        comment.post_id = comment.parent_comment.post_id unless comment_params[:post_id]
        post = comment.post_id
        if comment.save
            redirect_to post_url(post)
        else
            flash.now[:errors] = comment.errors.full_messages
            render :new
        end
    end

    def show
        @parent_id = params[:id]
        render :show
    end

    def upvote
        vote(Vote.new(votable_id: params[:id], value: 1, votable_type: "Comment"))
    end
    
    def downvote
        vote(Vote.new(votable_id: params[:id], value: -1, votable_type: "Comment"))
    end

    private
    def comment_params
        params.require(:comment).permit(:content, :post_id, :parent_comment_id)
    end

    def vote(vote)
        vote.save
        flash.now[:errors] = vote.errors.full_messages if vote.errors
        redirect_to comment_url(vote.votable_id)
    end
end