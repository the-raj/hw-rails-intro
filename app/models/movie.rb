class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.uniq.pluck(:rating)
    end
    
    def self.with_ratings(ratings, sort)
        if ratings.nil?
            Movie.order(sort)
        else
            Movie.where(rating: ratings).order(sort)
        end
    end
end