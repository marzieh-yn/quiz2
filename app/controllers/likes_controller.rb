class LikesController < ApplicationController
  before_action :authenticate_user!

    def create
        # When we create a like, we will provide the review id for the like to belong to
        review = Review.find params[:review_id]
        like = Like.new user: current_user, review: review
        if !can?(:like, review)
            flash[:alert] = "You can't like your own review"
        elsif like.save
            flash[:success] = "Review Liked!"
            redirect_to like.review.idea
        else
            flash[:warning] = like.errors.full_messages.join(', ')
        end
    end

    def destroy
        # When we destroy a like, we want to provide the like id directly to destroy
        like = Like.find params[:id]
        # This is defined in ability.rb
        if can? :destroy, like
            like.destroy
            flash[:success] = "Unliked Review"
            redirect_to like.review.idea
        else 
            flash[:alert] = "Could not like review"
            redirect_to like.review.idea
        end
    end

  def create
  end
end
