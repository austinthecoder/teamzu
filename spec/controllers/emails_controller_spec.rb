require 'spec_helper'

describe EmailsController do
  include Devise::TestHelpers

  before do
    @user = Factory(:user)
    @team = Factory(:team, :user => @user)
    @players = (1..2).map { |i| Factory(:player, :id => i, :team => @team) }
    @params = {:team_id => @team.id, :bulk_player_id => "1:2"}
    sign_in @user
    controller.stub!(:current_user => @user, :team => @team, :players => @players)
  end

  ##################################################

  describe "GET new" do
    before { @players.each { |p| p.email = Factory.next(:email) } }

    it "calls #ensure_emailable_players" do
      controller.should_receive(:ensure_emailable_players)
      get :new, @params
    end

    it "renders the 'new' template" do
      get :new, @params
      response.should render_template('new')
    end
  end

  ##################################################

  describe "POST create" do
    before { @players.each { |p| p.email = Factory.next(:email) } }

    it "calls #ensure_emailable_players" do
      controller.should_receive(:ensure_emailable_players)
      post :create, @params
    end

    context "when the message is blank" do
      before { post :create, @params }

      it("adds flash alert") { flash[:alert].should == "Looks like you left the message blank." }
      it("renders 'new' template") { response.should render_template('new') }
    end

    context "when the message is not blank" do
      before do
        @params.merge!(:email => {:message => "message", :subject => "subject"})
        @mail_message = mock(Mail::Message, :deliver => nil)
        PlayerMailer.stub!(:bulk_message => @mail_message)
      end

      it "sends message to PlayerMailer" do
        PlayerMailer.should_receive(:bulk_message).with(@players, @user.email, "subject", "message")
        post :create, @params
      end

      it "sends deliver to the Mail::Message" do
        @mail_message.should_receive(:deliver)
        post :create, @params
      end

      it "adds flash notice" do
        post :create, @params
        flash[:notice].should == "Message was sent to players."
      end

      it "redirects to team url" do
        post :create, @params
        response.should redirect_to(team_url(@team))
      end
    end
  end

  ##################################################

  describe "#ensure_emailable_players" do
    before { controller.stub!(:players => []) }

    context "if all of the players have an email" do
      before { controller.players << Factory(:player, :email => 'a@b.com') }

      it "does not redirect" do
        controller.should_not_receive(:redirect_to)
        controller.ensure_emailable_players
      end
    end

    context "if any of the players does not have an email" do
      before do
        controller.players << Factory(:player, :email => '')
        controller.stub!(:redirect_to => nil)
      end

      it("adds flash alert") do
        controller.ensure_emailable_players
        flash[:alert].should == "Some of the players selected do not have an email address."
      end

      it("redirects to the team_url") do
        controller.should_receive(:redirect_to).with(team_url(@team))
        controller.ensure_emailable_players
      end
    end
  end

end

