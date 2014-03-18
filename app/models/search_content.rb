class SearchContent < ActiveRecord::Base
  belongs_to :recipe

  validates :title, presence: true
  validates :content, presence: true

  before_save :analyze_title_and_content

  private
  def analyze_title_and_content
    nm = Natto::MeCab.new(node_format: '%m\s%f[7]\s')
    self.title = nm.parse(self.title)
    self.content = nm.parse(self.content)
  end
end
