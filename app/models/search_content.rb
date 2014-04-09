class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :origin_title, presence: true
  validates :origin_content, presence: true

  before_save :analyze_title_and_content

  scope :fulltext_search, ->(query_string) {
    where("match(search_contents.title,search_contents.content) against(? in boolean mode)", query_string)
  }

  scope :ngram_search, ->(query_string) {
    where("match(search_contents.title_ngram,search_contents.content_ngram) against (? in boolean mode)", query_string)
  }

  def self.search(query_string)
    query_array = query_string.split(/[[:space:]]/)
    where("#{fulltext_search(surface_and_yomi_string(query_array)).where_values[0]} OR #{ngram_or_like(query_array).where_values[0]}").order(:title_yomi)
  end

  def self.ngram_or_like(query_array)
    if query_array.find { |q| q.size == 1 }
      #like_search
    else
      ngram_search(ngram_search_string(query_array))
    end
  end


  def self.surface_and_yomi_string(query_array)
    query_array.map { |q| "+(#{q} #{Analyze.parse(q, '-Oyomi')})" }.join(' ')
  end

  def self.ngram_search_string(query_array)
    query_array.map { |q| "+(+#{Analyze.ngram(q, ' +')})" }.join(' ')
  end

  private_class_method :surface_and_yomi_string, :ngram_search_string

  private
  def analyze_title_and_content
    self.title = Analyze.parse(self.origin_title)
    self.title_yomi = Analyze.parse(self.origin_title, '-Oyomi')
    self.title_ngram = Analyze.ngram(self.origin_title)
    self.content = Analyze.parse(self.origin_content)
    self.content_ngram = Analyze.ngram(self.origin_content)
  end
end
