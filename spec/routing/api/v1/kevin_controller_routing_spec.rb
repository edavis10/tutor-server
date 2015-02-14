require "rails_helper"

describe Api::V1::KevinsController, :type => :routing, :api => true, :version => :v1 do

  describe "/api/kevins" do
    it "routes to #index" do
      expect(get '/api/kevins').to route_to('api/v1/kevins#index', format: 'json')
    end
  end

end
