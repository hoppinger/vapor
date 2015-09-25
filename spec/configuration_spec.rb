require "spec_helper"

RSpec.describe Vapor::Configuration do
  let(:vapor) { Vapor }

  it "should have a default configuration" do
    expect(vapor.configuration).not_to eq(nil)
  end

  it "should have a default base_url" do
    expect(vapor.configuration.base_url).not_to eq("http://www.hoppinger.com")
  end

  it "should have a default username" do
    expect(vapor.configuration.username).not_to eq("username")
  end

  it "should have a default password" do
    expect(vapor.configuration.password).not_to eq("password")
  end
end
