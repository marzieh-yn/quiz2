class Idea < ApplicationRecord
    has_many :favourites, dependent: :destroy
    has_many :favouriters, through: :favourites, source: :user

    before_destroy :log_delete_details, unless: Proc.new { !Rails.env.development? }
  
    validates(:title,
      presence: true,
      uniqueness: true,
      exclusion:
        { in: ['apple', 'microsoft', 'sony'],
          message: "%{value} is a reserved title. Please use a different title"
        }
    )
    validates :description, presence: true, length: { minimum: 10 }
  
    belongs_to :user
    # has_many accepts a scope as a second argument. This scope will make all associated reviews ordered by their updated_at, see the following example:
    # @idea = Idea.find(params[:id])
    # @idea.reviews # will be all the associated reviews for this particular idea and due to the scope they're all ordered by updated_at
  
  
    has_many :reviews, -> { order('updated_at DESC') }, dependent: :destroy 
  
    # scope(name, body, &block) is a method that will add a class method for retrieving records
    # https://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html#method-i-scope
    # in ruby & rails docks &block means the method accepts a lambda.
    scope(:search, -> (query) { where("title ILIKE?", "%#{query}%") })
  
    # you can create a class method that does the same thing.
  
    def self.search_but_using_class_method(query)
      where("title ILIKE?", "%#{query}%")
    end
  
    def self.get_paginated(search, sort_by_col, current_page, per_page_count)
      where("title ILIKE ? OR description ILIKE ?", "%#{search}%", "%#{search}%").order(Hash[sort_by_col, :desc]).limit(per_page_count).offset(current_page * per_page_count) 
    end
  
    private
  
    
    def capitalize_title
      self.title.capitalize!
    end
  
   
    def log_delete_details
      puts "idea #{self.id} is about to be deleted"
    end
  

  end
  