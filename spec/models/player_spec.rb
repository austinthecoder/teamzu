require 'spec_helper'

describe Player do
  
  it { should normalize_attribute(:name).from("  John Smith ").to("John Smith") }
  
  describe "validations" do
    before { @player = Factory.build(:player) }
    
    context "when the name is blank" do
      it "has 1 error on name" do
        @player.name = nil
        @player.valid?
        @player.should have(1).error_on(:name)
      end
    end
    
    context "when the team is nil" do
      it "has 1 error on team" do
        @player.team = nil
        @player.valid?
        @player.should have(1).error_on(:team)
      end
    end
  end
  
end