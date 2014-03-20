require "spec_helper"

describe SearchesController do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/searches").to route_to("searches#index")
    end
  end
end