class AddTitleNgramAndContentNgramToSearchContent < ActiveRecord::Migration
  def self.up
    add_column :search_contents, :title_ngram, :string
    add_column :search_contents, :content_ngram, :text
    SearchContent.all.each do |sc|
      sc.update(title_ngram: Analyze.ngram(sc.origin_title), content_ngram: Analyze.ngram(sc.origin_content))
    end
  end

  def self.down
    remove_column :search_contents, :title_ngram
    remove_column :search_contents, :content_ngram
  end
end
