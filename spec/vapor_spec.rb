require "spec_helper"

RSpec.describe Vapor do
  describe "." do
    describe "options" do
      it "returns a hash" do
        expect(Vapor.options).to eq(log: true, logger: nil, overwrite: false)
      end
    end

    describe "configuration" do
      it "returns a Vapor::Configuration" do
        expect(Vapor.configuration).to be_a(Vapor::Configuration)
      end
    end

    describe "logger" do
      it "returns a Vapor::Logger" do
        expect(Vapor.logger).to be_a(::Logger)
      end
    end

    describe "configure" do
      let(:base_url) { "http://www.hoppinger.com" }
      let(:username) { "username" }
      let(:password) { "password" }

      before :each do
        Vapor.configure do |config|
          config.base_url = base_url
          config.username = username
          config.password = password
        end
      end

      it "sets base_url" do
        expect(Vapor.configuration.base_url).to eq(base_url)
      end

      it "sets username" do
        expect(Vapor.configuration.username).to eq(username)
      end

      it "sets password" do
        expect(Vapor.configuration.password).to eq(password)
      end
    end
  end
end
