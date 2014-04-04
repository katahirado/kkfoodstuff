class AddNgramFulltextIndexToSearchContents < ActiveRecord::Migration
  def self.up
    execute 'create fulltext index search_contents_ngram_fulltext_index on search_contents (title_ngram,content_ngram);'
  end

  def self.down
    execute 'drop index search_contents_ngram_fulltext_index on search_contents;'
  end
end
