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
        @team = @user.teams.new
        @user.teams.stub!(:new => @team)
        get :new
      end
      
      it("builds a team") { assigns(:team).should == @team }
      it("renders the 'new' template") { response.should render_template('new') }
    end
    
    describe "POST create" do
      before do
        @team_attrs = Factory.attributes_for(:team)
        @team = mock_model(Team, :save => true)#@user.teams.new(@team_attrs)
        @user.teams.stub!(:new => @team)
      end
      
      it "builds a team" do
        post :create, :team => @team_attrs
        assigns(:team).should == @team
      end
      
      context "saving the team succeeds" do
        before do
          post :create, :team => @team_attrs
        end
        
        it("adds flash notice") { flash[:notice].should == "Team was created." }
        it("redirects") { response.should redirect_to(teams_url) }
      end
      
      context "saving the team fails" do
        it("renders the 'new' template") do
          @team.stub!(:save => false)
          post :create, :team => @team_attrs
          response.should render_template('new')
        end
      end
    end
  end
  
  describe "member actions" do
    before do
      @team = Factory(:team, :user => @user)
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