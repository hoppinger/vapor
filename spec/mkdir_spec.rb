require "spec_helper"

RSpec.describe "mkdir" do
  it "should create a directory" do
    vapor = Vapor::OwnCloud.new
    expect(vapor).not_to be_nil
  end
end
