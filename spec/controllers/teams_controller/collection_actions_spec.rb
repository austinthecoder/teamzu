require 'spec_helper'

describe TeamsController, "collection actions" do
  
  include Devise::TestHelpers
  
  before do
    sign_in Factory(:user)
  end
  
  describe "GET index" do
    before do
      @teams = (1..2).map { mock_model(Team) }
      controller.current_user.teams.stub!(:paginate => @teams)
    end
    
    [1, 10].each do |page|
      it "should paginate the teams" do
        controller.current_user.teams.should_receive(:paginate).with(
          :page => page,
          :per_page => 20,
          :order => "created_at DESC"
        )
        get :index, :page => page
      end
    end
    
    it "should assign the teams" do
      get :index
      assigns(:teams).should == @teams
    end
  end
  
  describe "GET new" do
    it "should build a team" do
      controller.should_receive(:build_team)
      get :new
    end
  end
  
  describe "POST create" do
    before do
      @team = mock_model(Team, :save => true)
      controller.stub!(:team => @team)
    end
    
    it "should build a team" do
      controller.should_receive(:build_team)
      post :create
    end
    
    it "should save the team" do
      @team.should_receive(:save)
      post :create
    end
    
    it "should respond with the team" do
      controller.stub!(:render => nil)
      controller.should_receive(:respond_with).with(@team, :location => teams_url)
      post :create
    end
    
    it "should add a flash notice when saving the team succeeds" do
      post :create
      flash[:notice].should == "Team was created."
    end
  end
  
end