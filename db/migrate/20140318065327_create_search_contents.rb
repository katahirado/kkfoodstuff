class CreateSearchContents < ActiveRecord::Migration
  def change
    create_table :search_contents do |t|
      t.references :recipe, index: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
