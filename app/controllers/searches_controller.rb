class SearchesController < ApplicationController
  def index
    @recipes = @search.valid? ? @search.recipes : []
  end
end
