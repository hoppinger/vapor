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
    describe "exists?" do
      it "should return true if path exists" do
        expect(Vapor.exists?("existing.file")).to eq(true)
      end

      it "should return false if path does not exist" do
        expect(Vapor.exists?("non-existing.file")).to eq(false)
      end
    end

    describe "delete_file" do
      it "should delete file if it exists" do
        expect(Vapor.delete_file("existing.file")).to eq(true)
      end

      it "should not delete file if it does not exist" do
        expect(Vapor.delete_file("non-existing.file")).to eq(false)
      end
    end

    describe "put_file" do
      xit "should put file if it exists and options[:overwrite] = true" do
        Vapor.options[:overwrite] = true
        expect(Vapor.put_file("existing.file", "existing.file")).to eq(true)
      end

      xit "should put file if it does not exist" do
        expect(Vapor.put_file("non-existing.file", "non-existing.file")).to eq(true)
      end

      it "should not put file if it exists and options[:overwrite] = false" do
        Vapor.options[:overwrite] = false
        expect(Vapor.put_file("existing.file", "existing.file")).to eq(false)
      end
    end

    describe "get_file" do
      it "should return file if path does not exist" do
        expect(Vapor.get_file("non-existing.file")).to eq(false)
      end

      it "should get file if it exists" do
        expect(Vapor.get_file("existing.file")).to eq("content")
      end

      it "should get file if it exists and write to target if target_path exists" do
        expect(Vapor.get_file("existing.file", "target.file")).to eq(true)
      end
    end

    describe "mkdir" do
      it "should create a directory if it does not exist" do
        expect(Vapor.mkdir("non-existing")).to match_array([true])
      end

      xit "should recursively create a directories if they do not exist" do
        expect(Vapor.mkdir("non-existing/non-existing")).to match_array([true, true])
      end

      it "should not recursively create a directories if they do not exist" do
        expect(Vapor.mkdir("existing/non-existing")).to match_array([false, true])
      end

      it "should not create a directory if it exists" do
        expect(Vapor.mkdir("existing")).to match_array([false])
      end
    end
  end
end
