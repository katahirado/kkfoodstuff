require 'spec_helper'

describe SearchesController do

  describe "GET 'index'" do
    before(:all) do
      DatabaseCleaner.strategy = :truncation
    end

    after(:all) do
      DatabaseCleaner.strategy = :transaction
    end

    it "returns http success" do
      get :index
      expect(response).to be_success
    end

    it "assigns search result recipes as @recipes" do
      word = '白菜'
      recipe = FactoryGirl.create(:recipe, title: word)
      get :index,search: { word: word}
      expect(assigns(:recipes)).to eq([recipe])
    end
  end

end
