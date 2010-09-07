require 'spec_helper'

def assigns_the_team
  yield
  assigns(:team).should == @team
end

def assigns_the_player
  @player = @team.players.new
  @team.players.stub!(:new => @player)
  yield
  assigns(:player).should == @player
end

def builds_a_player
  @team.players.should_receive(:new).with(@player_attrs)
  yield
end

##################################################

describe PlayersController do
  include Devise::TestHelpers
  
  before do
    @user = Factory(:user)
    sign_in @user
    controller.stub!(:current_user => @user)
  end
  
  ##################################################
  
  describe "GET new" do
    before do
      @player_attrs = Factory.attributes_for(:player).stringify_keys
    end
    
    context "when that team does not exist" do
      it "renders 404" do
        pending
        lambda { get :new, :team_id => '1' }
        response.code.should == 404
      end
    end
    
    context "when that team exists" do
      before do
        @team = Factory(:team, :user => @user)
        @user.stub!(:teams => mock(Array, :find => @team))
      end
      
      it "assigns the team" do
        assigns_the_team { get :new, :team_id => @team.id }
      end
      
      it "builds a player" do
        builds_a_player { get :new, :team_id => @team.id, :player => @player_attrs }
      end
      
      it "assigns the player" do
        assigns_the_player { get :new, :team_id => @team.id }
      end
      
      it "renders the 'new' template" do
        get :new, :team_id => @team.id
        response.should render_template('new')
      end
    end
  end
  
  ##################################################
  
  describe "POST create" do
    context "when that team exists" do
      before do
        @player_attrs = Factory.attributes_for(:player).stringify_keys
        @team = Factory(:team, :user => @user)
      end
      
      it "assigns the team" do
        assigns_the_team { post :create, :team_id => @team.id }
      end
      
      it "builds a player" do
        new_player = @team.players.new(@player_attrs)
        players = mock(Array, :new => new_player)
        @team.stub!(:players => players)
        teams = mock(Array, :find => @team)
        @user.stub!(:teams => teams)
        builds_a_player { post :create, :team_id => @team.id, :player => @player_attrs }
      end
      
      it "assigns the player" do
        @user.stub!(:teams => mock(Array, :find => @team))
        assigns_the_player { post :create, :team_id => @team.id }
      end
      
      context "when saving the player succeeds" do
        before { post :create, :team_id => @team.id, :player => @player_attrs }
        
        it("adds flash notice") { flash[:notice].should == "Player was added." }
        it("redirects") { response.should redirect_to(team_url(@team)) }
      end
      
      context "when saving the player fails" do
        it("renders the 'new' template") do
          post :create, :team_id => @team.id
          response.should render_template('new')
        end
      end
    end
  end
  
end