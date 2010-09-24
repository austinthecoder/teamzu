require 'spec_helper'

describe Player do

  it { should normalize_attribute(:name).from("  John Smith ").to("John Smith") }
  it { should normalize_attribute(:email).from("  x@b.com ").to("x@b.com") }

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

  describe ".emailable" do
    it "calls where" do
      Player.should_receive(:where).with(['email != ? OR email != ?', nil, ''])
      Player.emailable
    end

    it "returns the relation" do
      relation = mock(ActiveRecord::Relation)
      Player.stub!(:where => relation)
      Player.emailable.should == relation
    end
  end

end