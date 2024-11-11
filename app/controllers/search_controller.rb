class SearchController < ApplicationController
  def index
    query = params[:query]

    @dishes = @restaurant.dishes.where("(LOWER(name) LIKE ? OR LOWER(description) LIKE ?) AND deleted_at IS NULL", "%#{query.downcase}%", "%#{query.downcase}%")
    @drinks = @restaurant.drinks.where("(LOWER(name) LIKE ? OR LOWER(description) LIKE ?) AND deleted_at IS NULL", "%#{query.downcase}%", "%#{query.downcase}%")

    render :index
  end
end
