class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :origin_title, presence: true
  validates :origin_content, presence: true

  before_save :analyze_title_and_content

  scope :fulltext_search, ->(query_string) {
    where("match(search_contents.title,search_contents.content) against(? in boolean mode)", Analyze.parse(query_string))
  }

  scope :like_search, ->(query_string) {
    where(arel_table[:origin_title].matches("%#{query_string}%").or(
            arel_table[:origin_content].matches("%#{query_string}%")).or(
            arel_table[:title].matches("%#{query_string}%")).or(
            arel_table[:content].matches("%#{query_string}%")
          ))
  }

  def self.search(query_string)
    where("#{fulltext_search(query_string).where_values[0]} OR #{like_search(query_string).where_values.inject(:or).to_sql}")
  end

  private
  def analyze_title_and_content
    self.title = Analyze.parse(self.origin_title)
    self.content = Analyze.parse(self.origin_content)
  end
end
