require 'spec_helper'

describe User do
  
  it { should normalize_attribute(:email).from("  x@y.com \n").to("x@y.com") }
  
  describe "#remember_me" do
    before { @user = User.new }
    
    it { @user.remember_me.should be_true }
    
    [true, false].each do |bool|
      context "when remember_me is set to #{bool}" do
        before { @user.remember_me = bool }
        
        it { @user.remember_me.should send("be_#{bool}") }
      end
    end
  end
  
end