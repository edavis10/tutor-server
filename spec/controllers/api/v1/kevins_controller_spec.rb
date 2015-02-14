require "rails_helper"

describe Api::V1::KevinsController, :type => :controller, :api => true, :version => :v1 do

  describe "#index" do
    it "should return OK (200) code" do
      api_get :index, nil
      expect(response.code).to eq('200')
    end

    it "should return fixed json" do
      api_get :index, nil
      expect(response.code).to eq('200')
      expect(response.body).to eq({
        field1: 0,
        field2: [1, 2, 3]
      }.to_json)
    end
  end

  describe "#convert" do
    it "should convert 2 to 3" do
      api_post :convert, nil, raw_post_data: {field1: 2, field2: [4,5,6]}
      expect(response.code).to eq('200')
      expect(response.body).to eq({
        field1: 3,
        field2: [4,5,6]
      }.to_json)
    end

    it "should convert 4 to 5" do
      api_post :convert, nil, raw_post_data: {field1: 4, field2: [4,5,6]}
      expect(response.code).to eq('200')
      expect(response.body).to eq({
        field1: 5,
        field2: [4,5,6]
      }.to_json)
    end
  end

end
