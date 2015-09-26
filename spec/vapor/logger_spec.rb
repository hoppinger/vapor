require "spec_helper"

RSpec.describe Vapor::Logger do
  describe "." do
    it "log" do
      expect(Vapor.log("test")).to eq(true)
    end
  end
end
