require 'spec_helper'


describe RecipesController do

  describe "GET index" do
    it "assigns all recipes as @recipes" do
      recipe = FactoryGirl.create(:recipe)
      get :index
      expect(assigns(:recipes)).to eq([recipe])
    end
  end

  describe "GET show" do
    it "assigns the requested recipe as @recipe" do
      recipe = FactoryGirl.create(:recipe)
      get :show, id: recipe.to_param
      expect(assigns(:recipe)).to eq(recipe)
    end
  end

  describe "GET new" do
    it "assigns a new recipe as @recipe" do
      get :new
      expect(assigns(:recipe)).to be_a_new(Recipe)
    end
  end

  describe "GET edit" do
    it "assigns the requested recipe as @recipe" do
      recipe = FactoryGirl.create(:recipe)
      get :edit, id: recipe.to_param
      expect(assigns(:recipe)).to eq(recipe)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Recipe" do
        expect {
          post :create, recipe: FactoryGirl.attributes_for(:recipe)
        }.to change(Recipe, :count).by(1)
      end

      it "assigns a newly created recipe as @recipe" do
        post :create, recipe: FactoryGirl.attributes_for(:recipe)
        expect(assigns(:recipe)).to be_a(Recipe)
        expect(assigns(:recipe)).to be_persisted
      end

      it "redirects to the created recipe" do
        post :create, recipe: FactoryGirl.attributes_for(:recipe)
        expect(response).to redirect_to(recipes_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved recipe as @recipe" do
        post :create, recipe: {title: "invalid value"}
        expect(assigns(:recipe)).to be_a_new(Recipe)
      end

      it "re-renders the 'new' template" do
        post :create, recipe: {title: "invalid value"}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested recipe" do
        recipe = FactoryGirl.create(:recipe)
        put :update, id: recipe.to_param, recipe: {title: 'update title'}
        expect(Recipe.last.title).to eq('update title')
      end

      it "redirects to the recipe" do
        recipe = FactoryGirl.create(:recipe)
        put :update, id: recipe.to_param, recipe: FactoryGirl.attributes_for(:recipe)
        expect(response).to redirect_to(recipes_path)
      end
    end

    describe "with invalid params" do
      it "assigns the recipe as @recipe" do
        recipe = FactoryGirl.create(:recipe)
        put :update, {:id => recipe.to_param, :recipe => {title: nil}}
        expect(assigns(:recipe)).to eq(recipe)
      end

      it "re-renders the 'edit' template" do
        recipe = FactoryGirl.create(:recipe)
        put :update, {id: recipe.to_param, recipe: {title: nil}}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested recipe" do
      recipe = FactoryGirl.create(:recipe)
      expect {
        delete :destroy, {id: recipe.to_param}
      }.to change(Recipe, :count).by(-1)
    end

    it "redirects to the recipes list" do
      recipe = FactoryGirl.create(:recipe)
      delete :destroy, {id: recipe.to_param}
      expect(response).to redirect_to(recipes_url)
    end
  end

end
