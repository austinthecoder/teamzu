require 'spec_helper'

describe ApplicationController do
  include Devise::TestHelpers

  describe "#teams_scope" do
    context "when logged in" do
      before do
        @current_user = Factory(:user)
        sign_in @current_user
        controller.stub!(:current_user => @current_user)
      end

      it "sends current_user#teams" do
        @current_user.should_receive(:teams)
        controller.teams_scope
      end

      it "assigns the teams_scope" do
        relation = mock(ActiveRecord::Relation)
        @current_user.stub!(:teams => relation)
        controller.teams_scope
        assigns(:teams_scope).should == relation
      end
    end

    context "when not logged in" do
      it "raises an error" do
        lambda { controller.teams_scope }.should raise_error
      end
    end
  end

end
