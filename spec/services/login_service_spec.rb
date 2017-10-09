require "rails_helper"

describe LoginService do
  before :each do
    stub_request(:post, LoginService::URL)
      .with(body: { username: "abc", password: "123" })
      .to_return(body: "{\"email\":\"abc\"}")
  end

  context "#perform" do
    it "requests login api once" do
      service = LoginService.new("abc", "123")
      service.perform

      expect(WebMock).to have_requested(:post, LoginService::URL).once
    end
  end

  context "#success?" do
    it "return true if logged in" do
      service = LoginService.new("abc", "123")
      service.perform

      expect(service.success?).to be_truthy
    end
  end
end
