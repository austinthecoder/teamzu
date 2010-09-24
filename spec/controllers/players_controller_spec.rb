require 'spec_helper'

def assigns_the_team
  yield
  assigns(:team).should == @team
end

##################################################

describe PlayersController do
  include Devise::TestHelpers

  before do
    @user = Factory(:user)
    sign_in @user
    @team = Factory(:team, :user => @user)
    controller.stub!(
      :current_user => @user,
      :team => @team
    )
    @params = {:team_id => @team.id}
  end

  ##################################################

  describe "GET new" do
    it "renders the 'new' template" do
      get :new, @params
      response.should render_template('new')
    end
  end

  ##################################################

  describe "POST create" do
    context "when saving the player succeeds" do
      before { post :create, @params.merge(:player => Factory.attributes_for(:player)) }

      it("adds flash notice") { flash[:notice].should == "Player was added." }
      it("redirects") { response.should redirect_to(team_url(@team)) }
    end

    context "when saving the player fails" do
      before { post :create, @params }

      it("renders the 'new' template") { response.should render_template('new') }
    end
  end

  ##################################################

  describe "GET bulk" do
    before do
      @params.merge!(:bulk_action => 'email', :player_ids => [1, 2])
    end

    it "passes the player_ids to team#players#find" do
      controller.players_scope.should_receive(:find).with([1, 2])
      get :bulk, @params
    end

    context "when no players are found" do
      it "redirects to the team's page" do
        get :bulk, @params
        response.should redirect_to(team_url(@team))
      end
    end

    context "when players are found" do
      before { controller.players_scope.stub!(:find => mock_model(Player)) }

      context "when the bulk_action is 'email'" do
        it "redirects" do
          get :bulk, @params
          response.should redirect_to(new_team_bulk_player_email_path(@team, "1:2"))
        end
      end

      context "when the bulk_action is 'alkjfoiaskf'" do
        before { @params.merge!(:bulk_action => 'alkjfoiaskf') }

        it "redirects" do
          get :bulk, @params
          response.should redirect_to(team_url(@team))
        end
      end
    end
  end

  ##################################################

  describe "member actions" do
    before do
      @player = Factory(:player, :team => @team)
      controller.stub!(:player => @player)
      @params.merge!(:id => @player.id)
    end

    describe "GET delete" do
      before { get :delete, @params }

      it("renders the 'delete' template") { response.should render_template('delete') }
    end

    describe "DELETE destroy" do
      before { delete :destroy, @params }

      it("destroys the player") { @player.should be_destroyed }
      it("adds flash notice") { flash[:notice].should == "Player was removed." }
      it("redirects") { response.should redirect_to(team_url(@team)) }
    end

    describe "GET edit" do
      before { get :edit, @params }

      it("renders the 'edit' template") { response.should render_template('edit') }
    end

    describe "PUT update" do
      before do
        @player_attrs = Factory.attributes_for(:player)
        @params.merge!(:player => @player_attrs)
      end

      it "updates the player" do
        @player.should_receive(:update_attributes).with(@player_attrs.stringify_keys)
        put :update, @params
      end

      context "when updating the player succeeds" do
        before { put :update, @params }

        it("adds flash notice") { flash[:notice].should == "Player was saved." }
        it("redirects") { response.should redirect_to(team_url(@team)) }
      end

      context "when updating the player fails" do
        before { put :update, @params.merge(:player => Factory.attributes_for(:invalid_player)) }

        it("renders the 'edit' template") { response.should render_template('edit') }
      end
    end
  end

  ##################################################

  describe "#team" do
    before do
      controller.stub!(:params => {:team_id => @team.id})
      controller.unstub!(:team)
    end

    it "passes the team_id to teams_scope#find" do
      controller.teams_scope.should_receive(:find).with(@team.id)
      controller.team
    end

    it "assigns the team" do
      controller.team
      assigns(:team).should == @team
    end
  end

  describe "#set_player" do
    it "passes the player_id to team#players#find" do
      controller.stub!(:params => {:id => 2437985})
      controller.players_scope.should_receive(:find).with(2437985)
      controller.set_player
    end

    it "assigns the player" do
      player = mock_model(Player)
      controller.players_scope.stub!(:find => player = mock_model(Player))
      controller.set_player
      assigns(:player).should == player
    end
  end

  describe "#build_player" do
    it "passes the player params to team#players#new" do
      controller.stub!(:params => {:player => {:a => '1'}})
      controller.players_scope.should_receive(:new).with({:a => '1'})
      controller.build_player
    end

    it "assigns the player" do
      player = mock_model(Player)
      controller.players_scope.stub!(:new => player)
      controller.build_player
      assigns(:player).should == player
    end
  end

end