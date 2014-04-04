class AddTitleYomiToSearchContent < ActiveRecord::Migration
  def self.up
    add_column :search_contents, :title_yomi, :string
    SearchContent.all.each do |sc|
      sc.update(title_yomi: Analyze.parse(sc.origin_title, '-Oyomi'))
    end
  end

  def self.down
    remove_column :search_contents, :title_yomi
  end
end
