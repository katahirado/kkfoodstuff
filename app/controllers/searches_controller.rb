class SearchesController < ApplicationController
  def index
    @recipes = Recipe.joins(:search_content).merge(SearchContent.fulltext_search(params[:word]))
  end
end
