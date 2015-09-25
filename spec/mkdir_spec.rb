require "spec_helper"

RSpec.describe "mkdir" do
  let(:vapor) { Vapor::OwnCloud }

  xit "should create a directory" do
    expect(vapor.mkdir("test")).to eq(true)
  end
end
