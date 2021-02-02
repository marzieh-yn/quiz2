class IdeasController < ApplicationController
  def new
  end

  def create
  end
    before_action :authenticate_user!, except: [:index, :show]
    before_action :load_idea!, except: [:create]
    before_action :authorize_user!, only: [:edit, :update, :destroy]
  
    def index
    
      @ideas = Idea.order(created_at: :DESC)

    end
  
    def new
    end
  
    def create
      # strong parameters are used primarily as a security practice to help
      # prevent accidentally allowing users to update sensitive model attributes.
   
      @idea = Idea.new idea_params
      @idea.user = @current_user
      if @idea.save
        # Eventually we will redirect to the show page for the idea created
        # render plain: "idea Created"
        # instead of the above line we will use :
        redirect_to @idea
        # same as redirect_to idea_path(@idea)
      else
        # render will simply render the new.html.erb view in the views/ideas
        # directory. The #new action above will not be touched.
        render :new
      end
    end
  
    # def index
    #   # @ideas = idea.all
    #   @ideas = idea.order(created_at: :DESC)
    # end
  
    def show
      @review = Review.new
    end
  
    def edit
    end
  
    def update
      # idea_params = params.require(:idea).permit(:title, :description, :price )
      @idea = Idea.find params[:id]
      if @idea.update idea_params
        redirect_to idea_path(@idea)
      else
        render :edit
      end
    end
    def destroy
      @idea.destroy
      redirect_to ideas_path
     end
  
     private
     def authorize_user!
      unless can? :crud, @idea
        flash[:danger] = "Acess Denied"
        redirect_to root_path
      end
     end
    
  
    def idea_params
      # docs about params.require() https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-require
      # docs about .permit() https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit
      params.require(:idea).permit(:title, :description, :price)
    end
  
     def load_idea!
      # params_tag= params[:tag]
      if params[:id].present?
        @idea = Idea.find(params[:id])
      else
        @idea = Idea.new
      end
     end
  
  end
  