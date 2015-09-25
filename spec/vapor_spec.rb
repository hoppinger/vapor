require "spec_helper"

RSpec.describe Vapor do
  describe "#" do
    describe "configure" do
      let(:username) { 'username' }

      before do
        Vapor.configure do |config|
          config.base_url = 'http://www.hoppinger.com'
          config.username = username
          config.password = 'password'
        end
      end

      it "returns an array with 10 elements" do
        dav = Vapor::OwnCloud.dav
        expect(dav).not_to eq(nil)
      end
    end
  end
end
