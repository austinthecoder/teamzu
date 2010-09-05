require 'spec_helper'

describe Team do
  
  it { should normalize_attribute(:name).from("  Strikers \n").to("Strikers") }
  
  describe "validations" do
    before { @team = Factory.build(:team) }
    
    context "when the name is blank" do
      before { @team.name = nil }
      it "has 1 error on name" do
        @team.valid?
        @team.should have(1).error_on(:name)
      end
    end
    
    context "when another user has a team of the same name" do
      before { Factory(:team, :name => @team.name) }
      it("is valid") { @team.should be_valid }
    end
    
    context "when its user has a team of the same name" do
      before { Factory(:team, :name => @team.name, :user => @team.user) }
      it "has 1 error on name" do
        @team.valid?
        @team.should have(1).error_on(:name)
      end
    end
  end
  
end