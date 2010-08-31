require 'spec_helper'

describe TeamsController, "member actions" do
  
  include Devise::TestHelpers
  
  before do
    sign_in Factory(:user)
  end
  
  describe "GET edit" do
    it "should find the team" do
      controller.should_receive(:find_team)
      get :edit, :id => '1'
    end
  end
  
  describe "PUT update" do
    before do
      @team = Factory(:team, :user => controller.current_user)
      controller.stub!(:team => @team)
    end
    
    it "should find the team" do
      controller.should_receive(:find_team)
      put :update, :id => '1'
    end
    
    it "should update the teams attributes" do
      team_attrs = {'name' => 'FooBar'}
      @team.should_receive(:update_attributes).with(team_attrs)
      put :update, :id => @team.id, :team => team_attrs
    end
    
    it "should respond with the team" do
      controller.stub!(:render => nil)
      controller.should_receive(:respond_with).with(@team, :location => teams_url)
      put :update, :id => @team.id
    end
    
    it "should add a flash notice when updating the attributes succeeds" do
      put :update, :id => @team.id
      flash[:notice].should == "Team was saved."
    end
  end
  
  describe "GET delete" do
    before do
      @team = Factory(:team, :user => controller.current_user)
      controller.stub!(:team => @team)
    end
    
    it "should find the team" do
      controller.should_receive(:find_team)
      get :delete, :id => '1'
    end
  end
  
  describe "DELETE destroy" do
    before do
      @team = Factory(:team, :user => controller.current_user)
      controller.stub!(:team => @team)
    end
    
    it "should find the team" do
      controller.should_receive(:find_team)
      delete :destroy, :id => '1'
    end
    
    it "should destroy the team" do
      delete :destroy, :id => @team.id
      @team.should be_destroyed
    end
    
    it "should respond with the team" do
      controller.stub!(:render => nil)
      controller.should_receive(:respond_with).with(@team, :location => teams_url)
      delete :destroy, :id => @team.id
    end
    
    it "should add a flash notice" do
      delete :destroy, :id => @team.id
      flash[:notice].should == "Team was deleted."
    end
  end
  
end