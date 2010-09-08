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
    @team = Factory(:team, :user => @user)
  end
  
  ##################################################
  
  describe "GET new" do
    before do
      @player_attrs = Factory.attributes_for(:player).stringify_keys
      @user.stub!(:teams => mock(Array, :find => @team))
    end
    
    it("assigns the team") { assigns_the_team { get :new, :team_id => @team.id } }
    it("assigns the player") { assigns_the_player { get :new, :team_id => @team.id } }
    
    it("builds a player") do
      builds_a_player { get :new, :team_id => @team.id, :player => @player_attrs }
    end
    
    it "renders the 'new' template" do
      get :new, :team_id => @team.id
      response.should render_template('new')
    end
  end
  
  ##################################################
  
  describe "POST create" do
    before { @player_attrs = Factory.attributes_for(:player).stringify_keys }
    
    it("assigns the team") { assigns_the_team { post :create, :team_id => @team.id } }
    
    it "builds a player" do
      @team.stub!(:players => mock(Array, :new => @team.players.new(@player_attrs)))
      @user.stub!(:teams => mock(Array, :find => @team))
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
  
  ##################################################
  
  describe "member actions" do
    before do
      @player = Factory(:player, :team => @team)
    end
    
    describe "GET delete" do
      before { get :delete, :team_id => @team.id, :id => @player.id }
      
      it("assigns the team") { assigns(:team).should == @team }
      it("assigns the player") { assigns(:player).should == @player }
      it("renders the 'delete' template") do
        response.should render_template('delete')
      end
    end
    
    describe "DELETE destroy" do
      before { delete :destroy, :team_id => @team.id, :id => @player.id }

      it("assigns the team") { assigns(:team).should == @team }
      it("assigns the player") { assigns(:player).should == @player }
      it("destroys the player") { assigns(:player).should be_destroyed }
      it("adds flash notice") { flash[:notice].should == "Player was removed." }
      it("redirects") { response.should redirect_to(team_url(@team)) }
    end
    
    describe "GET edit" do
      before { get :edit, :team_id => @team.id, :id => @player.id }
      
      it("assigns the team") { assigns(:team).should == @team }
      it("assigns the player") { assigns(:player).should == @player }
      it("renders the 'edit' template") do
        response.should render_template('edit')
      end
    end
    
    describe "PUT update" do
      before do
        @player_attrs = Factory.attributes_for(:player).stringify_keys
      end
      
      it("assigns the team") do
        put :update, :team_id => @team.id, :id => @player.id
        assigns(:team).should == @team
      end
      
      it "assigns the player" do
        put :update, :team_id => @team.id, :id => @player.id
        assigns(:player).should == @player
      end
      
      it "updates the player" do
        @user.stub!(:teams => mock(Array, :find => @team))
        @team.stub!(:players => mock(Array, :find => @player))
        @player.should_receive(:update_attributes).with(@player_attrs)
        put :update, :team_id => @team.id, :id => @player.id, :player => @player_attrs
      end
      
      context "when updating the player succeeds" do
        before { put :update, :team_id => @team.id, :id => @player.id, :player => @player_attrs }
        
        it("adds flash notice") { flash[:notice].should == "Player was saved." }
        it("redirects") { response.should redirect_to(team_url(@team)) }
      end
      
      context "when updating the player fails" do
        it("renders the 'edit' template") do
          put :update, :team_id => @team.id, :id => @player.id, :player => Factory.attributes_for(:invalid_player)
          response.should render_template('edit')
        end
      end
    end
  end
  
end