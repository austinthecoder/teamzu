require 'spec_helper'

describe TeamsController do
  include Devise::TestHelpers
  
  before do
    sign_in Factory(:user)
  end
  
  describe "#build_team" do
    it "should instantiate a team" do
      team_attrs = {:email => 'xyz'}
      controller.stub!(:params => {:team => team_attrs})
      controller.current_user.teams.should_receive(:new).with(team_attrs)
      controller.build_team
    end
    
    it "should assign the team" do
      team = Factory(:team)
      controller.current_user.teams.stub!(:new => team)
      controller.build_team
      assigns(:team).should == team
    end
  end
  
  describe "#find_team" do
    before do
      controller.stub!(:params => {:id => '1'})
    end
    
    it "should find the team" do
      controller.current_user.teams.should_receive(:find).with('1')
      controller.find_team
    end
    
    it "should assign the team if it finds it" do
      team = Factory(:team, :id => 1, :user => controller.current_user)
      controller.find_team
      assigns(:team).should == team
    end
    
    it "should raise an error when the team cannot be found" do
      controller.stub!(:params => {:id => '999'})
      lambda { controller.find_team }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
end