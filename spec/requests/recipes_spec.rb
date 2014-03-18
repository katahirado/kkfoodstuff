require 'spec_helper'

describe "Recipes" do
  describe "GET /recipes" do
    it "works! (now write some real specs)" do
      get recipes_path
      expect(response.status).to be(200)
    end
  end
end
