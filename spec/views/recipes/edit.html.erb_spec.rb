require 'spec_helper'

describe "recipes/edit" do
  before(:each) do
    @recipe = assign(:recipe, stub_model(Recipe,
      :title => "MyString",
      :book => "MyString",
      :content => "MyText"
    ))
  end

  it "renders the edit recipe form" do
    render

    assert_select "form[action=?][method=?]", recipe_path(@recipe), "post" do
      assert_select "input#recipe_title[name=?]", "recipe[title]"
      assert_select "input#recipe_book[name=?]", "recipe[book]"
      assert_select "textarea#recipe_content[name=?]", "recipe[content]"
    end
  end
end
