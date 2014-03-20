class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :title, presence: true
  validates :content, presence: true

  before_save :analyze_title_and_content

  scope :fulltext_search, ->(query_string) {
    where("match(search_contents.title,search_contents.content) against(?)", query_string)
  }

  private
  def analyze_title_and_content
    nm = Natto::MeCab.new(node_format: '%m\s%f[7]\s', unk_format: '%m\s', eos_format: '')
    self.title = nm.parse(self.title)
    self.content = nm.parse(self.content)
  end
end
