class AddFulltextIndexToSearchContents < ActiveRecord::Migration
  def self.up
    execute 'create fulltext index search_contents_fulltext_index on search_contents (title,content);'
  end

  def self.down
    execute 'drop index search_contents_fulltext_index on search_contents;'
  end
end
