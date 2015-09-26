require "spec_helper"

RSpec.describe Vapor::OwnCloud do
  xit "should create a directory" do
    expect(Vapor::OwnCloud.mkdir("test")).to eq(true)
  end
end
