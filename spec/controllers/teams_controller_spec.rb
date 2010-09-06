require 'spec_helper'

describe TeamsController do
  include Devise::TestHelpers
  
  shared_examples_for "a member action" do
    it("assigns the team") { assigns(:team).should == @team }
  end
  
  before do
    @user = Factory(:user)
    sign_in @user
    controller.stub!(:current_user => @user)
  end
  
  describe "collection actions" do
    describe "GET index" do
      before do
        @teams = (1..2).map { mock_model(Team) }
        @user.teams.stub!(:paginate => @teams)
      end
      
      it "paginates the teams" do
        @user.teams.should_receive(:paginate).with(
          :page => 13,
          :per_page => 20,
          :order => "created_at DESC"
        )
        get :index, :page => 13
      end
    
      it "assigns the teams" do
        get :index
        assigns(:teams).should == @teams
      end
    end
    
    describe "GET new" do
      before do
        @team_attrs = Factory.attributes_for(:team).stringify_keys
        @team = @user.teams.new(@team_attrs)
        @user.teams.stub!(:new => @team)
      end
      
      it "builds a team" do
        @user.teams.should_receive(:new).with(@team_attrs)
        get :new, :team => @team_attrs
      end
      
      it "assigns the team" do
        get :new
        assigns(:team).should == @team
      end
      
      it("renders the 'new' template") do
        get :new
        response.should render_template('new')
      end
    end
    
    describe "POST create" do
      before do
        @team_attrs = Factory.attributes_for(:team).stringify_keys
      end
      
      it "builds a team" do
        team = mock_model(Team, :save => true)
        @user.teams.should_receive(:new).with(@team_attrs).and_return(team)
        post :create, :team => @team_attrs
      end
      
      it "assigns the team" do
        team = @user.teams.new(@team_attrs)
        @user.teams.stub!(:new => team)
        post :create
        assigns(:team).should == team
      end
      
      context "when saving the team succeeds" do
        before { post :create, :team => @team_attrs }
        
        it("adds flash notice") { flash[:notice].should == "Team was created." }
        it("redirects") { response.should redirect_to(teams_url) }
      end
      
      context "when saving the team fails" do
        it("renders the 'new' template") do
          post :create
          response.should render_template('new')
        end
      end
    end
  end
  
  describe "member actions" do
    before do
      @team = Factory(:team, :user => @user)
    end
    
    describe "GET show" do
      before { get :show, :id => @team.id }
      
      it_should_behave_like "a member action"
      
      it("renders the 'show' template") { response.should render_template('show') }
    end

    describe "GET edit" do
      before { get :edit, :id => @team.id }

      it_should_behave_like "a member action"
      it("renders the 'edit' template") do
        response.should render_template('edit')
      end
    end

    describe "PUT update" do
      context "after" do
        before do
          @team_attrs = Factory.attributes_for(:team)
          put :update, :id => @team.id, :team => @team_attrs
        end

        it_should_behave_like "a member action"
        it("sets the attributes for the team") do
          @team_attrs.each { |a, v| assigns(:team).send(a).should == v }
        end

        context "with valid attributes" do
          it("assigned team is not changed") { assigns(:team).should_not be_changed }
          it("adds flash notice") { flash[:notice].should == "Team was saved." }
          it("redirects") { response.should redirect_to(teams_url) }
        end
      end

      context "with invalid attributes" do
        before do
          put :update, :id => @team.id, :team => Factory.attributes_for(:invalid_team)
        end
        
        it("renders the 'edit' template") do
          response.should render_template('edit')
        end
        it { assigns(:team).should be_changed }
      end
    end

    describe "GET delete" do
      before { get :delete, :id => @team.id }

      it_should_behave_like "a member action"
      it("renders the 'delete' template") do
        response.should render_template('delete')
      end
    end

    describe "DELETE destroy" do
      before { delete :destroy, :id => @team.id }

      it_should_behave_like "a member action"
      it { assigns(:team).should be_destroyed }
      it("adds flash notice") { flash[:notice].should == "Team was deleted." }
      it("redirects") { response.should redirect_to(teams_url) }
    end
  end
end