class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :origin_title, presence: true
  validates :origin_content, presence: true

  before_save :analyze_title_and_content

  scope :fulltext_search, ->(query_string) {
    where("match(search_contents.title,search_contents.content) against(? in boolean mode)", "#{query_string} #{Analyze.parse(query_string, '-Oyomi')}")
  }

  scope :ngram_search, ->(query_string) {
    where("match(search_contents.title_ngram,search_contents.content_ngram) against (? in boolean mode)", Analyze.ngram(query_string, ' +'))
  }

  def self.search(query_string)
    if query_string.split(/[[:space:]]/).size > 1
      ngram_search(query_string)
    else
      where("#{fulltext_search(query_string).where_values[0]} OR #{ngram_search(query_string).where_values[0]}")
    end.order(:title_yomi)
  end

  private
  def analyze_title_and_content
    self.title = Analyze.parse(self.origin_title)
    self.title_yomi = Analyze.parse(self.origin_title, '-Oyomi')
    self.title_ngram = Analyze.ngram(self.origin_title)
    self.content = Analyze.parse(self.origin_content)
    self.content_ngram = Analyze.ngram(self.origin_content)
  end
end
