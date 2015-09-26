require "spec_helper"

RSpec.describe Vapor::Configuration do
  let(:vapor) { Vapor }
  let(:configuration) { vapor.configuration }

  before do
    Vapor.configure do |config|
      config.base_url = "http://www.hoppinger.com"
      config.username = "username"
      config.password = "password"
    end
  end

  it "should have a default configuration" do
    expect(configuration).not_to eq(nil)
  end

  it "should have a default base_url" do
    expect(configuration.base_url).to eq("http://www.hoppinger.com")
  end

  it "should have a default username" do
    expect(configuration.username).to eq("username")
  end

  it "should have a default password" do
    expect(configuration.password).to eq("password")
  end
end
