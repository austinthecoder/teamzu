require 'spec_helper'

describe Team do
  
  describe "validations" do
    before do
      @team = Factory.build(:team)
    end
    
    context "when the name is blank" do
      it "should have 1 error on name" do
        @team.name = nil
        @team.valid?
        @team.should have(1).error_on(:name)
      end
    end
    
    context "when another user has a team of the same name" do
      it "should be valid" do
        Factory(:team, :name => @team.name)
        @team.should be_valid
      end
    end
    
    context "when its user has a team of the same name" do
      it "should have 1 error on name" do
        Factory(:team, :name => @team.name, :user => @team.user)
        @team.valid?
        @team.should have(1).error_on(:name)
      end
    end
  end
  
end