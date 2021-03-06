require "rails_helper"

describe Api::V1::TasksController, :type => :controller, :api => true, :version => :v1 do

  let!(:application)     { FactoryGirl.create :doorkeeper_application }
  let!(:user_1)          { FactoryGirl.create :user }
  let!(:user_1_token)    { FactoryGirl.create :doorkeeper_access_token, 
                                              application: application, 
                                              resource_owner_id: user_1.id }

  let!(:user_2)          { FactoryGirl.create :user }
  let!(:user_2_token)    { FactoryGirl.create :doorkeeper_access_token,
                                              application: application,
                                              resource_owner_id: user_2.id }

  let!(:userless_token)  { FactoryGirl.create :doorkeeper_access_token,
                                              application: application }

  let!(:task_1)            { FactoryGirl.create :task, title: 'A Task Title', step_types: [:tasked_reading, :tasked_exercise] }
  let!(:tasking_1)         { FactoryGirl.create :tasking, taskee: user_1, task: task_1 }

  describe "#show" do
    it "should work on the happy path" do
      api_get :show, user_1_token, parameters: {id: task_1.id}
      expect(response.code).to eq '200'
      expect(response.body_as_hash).to include(id: task_1.id)
      expect(response.body_as_hash).to include(title: 'A Task Title')
      expect(response.body_as_hash).to have_key(:steps)
      expect(response.body_as_hash[:steps][0]).to include(type: 'reading')
      expect(response.body_as_hash[:steps][1]).to include(type: 'exercise')
    end
  end

end