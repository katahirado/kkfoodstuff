class AddTitleYomiToSearchContent < ActiveRecord::Migration
  def change
    add_column :search_contents, :title_yomi, :string
  end
end
