class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :origin_title, presence: true
  validates :origin_content, presence: true

  before_save :analyze_title_and_content

  scope :fulltext_search, ->(query_array) {
    conditions = query_array.map { |q|
      where("match(search_contents.title,search_contents.content) against(? in boolean mode)", q).where_values[0]
    }.join(" AND ")
    where(conditions)
  }

  scope :ngram_search, ->(query_array) {
    conditions = query_array.map { |n|
      where("match(search_contents.title_ngram,search_contents.content_ngram) against (? in boolean mode)", n).where_values[0]
    }.join(" AND ")
    where(conditions)
  }

  scope :like_search, ->(query_array) {
    title_cont_all = query_array.map { |q| where("origin_title LIKE ? ", "%#{q}%").where_values[0] }.join(" AND ")
    content_cont_all = query_array.map { |q| where("origin_content LIKE ? ", "%#{q}%").where_values[0] }.join(" AND ")
    where("(#{title_cont_all}) OR (#{content_cont_all})")
  }

  def self.search(query_string)
    query_array = query_string.split(/[[:space:]]/)
    where("(#{fulltext_search(surface_and_yomi_strings(query_array)).where_values[0]}) OR #{ngram_or_like(query_array).where_values[0]}").order(:title_yomi)
  end

  def self.ngram_or_like(query_array)
    if query_array.find { |q| q.size == 1 }
      like_search(query_array)
    else
      ngram_search(ngram_strings(query_array))
    end
  end


  def self.surface_and_yomi_strings(query_array)
    query_array.map { |q| "#{q} #{Analyze.parse(q, '-Oyomi')}" }
  end

  def self.ngram_strings(query_array)
    query_array.map { |q| "+#{Analyze.ngram(q, ' +')}" }
  end

  private_class_method :surface_and_yomi_strings, :ngram_strings

  private
  def analyze_title_and_content
    self.title = Analyze.parse(self.origin_title)
    self.title_yomi = Analyze.parse(self.origin_title, '-Oyomi')
    self.title_ngram = Analyze.ngram(self.origin_title)
    self.content = Analyze.parse(self.origin_content)
    self.content_ngram = Analyze.ngram(self.origin_content)
  end
end
