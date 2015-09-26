require "spec_helper"

RSpec.describe Vapor::OwnCloud do
  let(:base_url) { "http://www.hoppinger.com" }
  let(:base_path) { "test" }
  let(:username) { "username" }
  let(:password) { "password" }

  before :each do
    Vapor.configure do |config|
      config.base_url = base_url
      config.base_path = base_path
      config.username = username
      config.password = password
    end
  end

  describe "." do
    describe "mkdir" do
      xit "should create a directory if it does not exist" do
        expect(Vapor.mkdir("non-existing")).to match_array([true])
      end

      xit "should recursively create a directories if they do not exist" do
        expect(Vapor.mkdir("non-existing/non-existing")).to match_array([true, true])
      end

      xit "should not recursively create a directories if they do not exist" do
        expect(Vapor.mkdir("existing/non-existing")).to match_array([false, true])
      end

      it "should not create a directory if it exists" do
        expect(Vapor.mkdir("existing")).to match_array([false])
      end
    end
  end
end
