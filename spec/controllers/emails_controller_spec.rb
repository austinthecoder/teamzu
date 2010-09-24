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

    it "renders the 'new' template" do
      get :new, @params
      response.should render_template('new')
    end
  end

  describe "POST create" do
    before { @players.each { |p| p.email = Factory.next(:email) } }

    context "when the message is blank" do
      before { post :create, @params }

      it("adds flash alert") { flash[:alert].should == "Looks like you left the message blank." }
      it("renders 'new' template") { response.should render_template('new') }
    end

    context "when the message is not blank" do
      before do
        @params.merge!(:email => {:message => "some message"})
        @mail_message = mock(Mail::Message, :deliver => nil)
        PlayerMailer.stub!(:message_email => @mail_message)
      end

      it "sends message to PlayerMailer" do
        PlayerMailer.should_receive(:message_email).with({
          :from => @user.email,
          :message => "some message",
          :to => @players.map(&:email)
        })
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

end

