class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :book
      t.text :content

      t.timestamps
    end
  end
end
