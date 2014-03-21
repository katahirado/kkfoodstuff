class CreateSearchContents < ActiveRecord::Migration
  def change
    create_table :search_contents, options: 'COLLATE=utf8_unicode_ci' do |t|
      t.references :recipe, index: true
      t.string :origin_title
      t.string :title
      t.text :origin_content
      t.text :content

      t.timestamps
    end
  end
end
