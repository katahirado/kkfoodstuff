class Search
  include ActiveModel::Model


  attr_accessor :word
  validates :word, presence: true

  def recipes
    Recipe.joins(:search_content).merge(SearchContent.search(word))
  end
end