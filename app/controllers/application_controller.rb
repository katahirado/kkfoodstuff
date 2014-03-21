class ApplicationController < ActionController::Base
  before_action :set_search

  protect_from_forgery with: :exception

  private
  def set_search
    @search = Search.new(params[:search])
  end
end
