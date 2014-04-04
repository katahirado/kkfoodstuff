class AddTitleYomiToSearchContent < ActiveRecord::Migration
  def self.up
    add_column :search_contents, :title_yomi, :string
  end

  def self.down
    remove_column :search_contents, :title_yomi
  end
end
