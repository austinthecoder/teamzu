require "spec_helper"

describe PlayerMailer do

  describe "bulk_message" do
    before do
      @players = (1..2).map { |i| mock_model(Player, :email => "x#{i}@example.com") }
      @subject = "this is the subject"
      @from = "me@example.com"
      @body = "this is the body"
      @email = PlayerMailer.bulk_message(@players, @from, @subject, @body)
      @email.deliver
    end

    it("delivers") { ActionMailer::Base.deliveries.should_not be_empty }
    it("sets to") { @email.to.should eq(@players.map(&:email)) }
    it("should set the subject") { @email.subject.should eq(@subject) }
    it("sets reply_to") { @email.reply_to.should eq([@from]) }
    it("sets from") { @email.from.should eq([Teamzu::MAILER_EMAIL]) }
    it("sets body") { @email.body.encoded.should eq(@body) }
  end

end
