require 'spec_helper'

describe "recipes/new" do
  before(:each) do
    assign(:recipe, stub_model(Recipe,
      :title => "MyString",
      :book => "MyString",
      :content => "MyText"
    ).as_new_record)
  end

  it "renders new recipe form" do
    render

    assert_select "form[action=?][method=?]", recipes_path, "post" do
      assert_select "input#recipe_title[name=?]", "recipe[title]"
      assert_select "input#recipe_book[name=?]", "recipe[book]"
      assert_select "textarea#recipe_content[name=?]", "recipe[content]"
    end
  end
end
