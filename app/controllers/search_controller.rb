class SearchController < ApplicationController
  def index
    query = params[:query]

    @dishes = Dish.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query.downcase}%", "%#{query.downcase}%")
    @drinks = Drink.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query.downcase}%", "%#{query.downcase}%")

    render :index
  end
end