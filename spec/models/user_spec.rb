require 'spec_helper'

describe User do
  
  describe "#remember_me" do
    it "should be true when not defined" do
      User.new.remember_me.should be_true
    end
    
    it "should return it's value after setting it" do
      user = User.new(:remember_me => false)
      user.remember_me.should be_false
    end
  end
  
end