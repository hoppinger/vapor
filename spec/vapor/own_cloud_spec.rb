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

    describe "move" do
      it "should return false if source file does not exist" do
        expect(Vapor.move("non-existing.file", "non-existing.file")).to eq(false)
      end

      it "should return false if source folder does not exist" do
        expect(Vapor.move("non-existing-folder", "non-existing-folder")).to eq(false)
      end

      it "should return false if destination file exists" do
        expect(Vapor.move("existing.file", "existing.file")).to eq(false)
      end

      it "should return false if destination folder exists" do
        expect(Vapor.move("existing-folder", "existing-folder")).to eq(false)
      end

      it "should return false if path does not exist" do
        expect(Vapor.move("non-existing.file", "non-existing.file")).to eq(false)
      end

      it "should move file" do
        expect(Vapor.move("existing.file", "non-existing.file")).to eq(true)
      end

      it "should move folder" do
        expect(Vapor.move("existing-folder", "non-existing-folder")).to eq(true)
      end
    end

    describe "delete" do
      it "should delete file if it exists" do
        expect(Vapor.delete("existing.file")).to eq(true)
      end

      it "should delete folder if it exists" do
        expect(Vapor.delete("existing-folder")).to eq(true)
      end

      it "should not delete file if it does not exist" do
        expect(Vapor.delete("non-existing.file")).to eq(false)
      end

      it "should not delete folder if it does not exist" do
        expect(Vapor.delete("non-existing-folder")).to eq(false)
      end
    end

    describe "put_file" do
      let(:file_path) { File.join(Dir.pwd, "spec", "fixtures", "non-existing.file") }
      it "should put file if it exists and options[:overwrite] = true" do
        puts Dir.pwd
        Vapor.options[:overwrite] = true
        expect(Vapor.put_file(file_path, "existing.file")).to eq(true)
        Vapor.options[:overwrite] = false
      end

      it "should put file if it does not exist" do
        expect(Vapor.put_file(file_path, "non-existing.file")).to eq(true)
      end

      it "should not put file if it exists and options[:overwrite] = false" do
        expect(Vapor.put_file(file_path, "existing.file")).to eq(false)
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

    describe "list_files" do
      it "should return false if path does not exist" do
        expect(Vapor.list_files("non-existing-folder")).to eq(false)
      end

      it "should return list of files if path exists" do
        expect(Vapor.list_files("existing-folder")).to eq([])
      end
    end

    describe "mkdir" do
      it "should create a directory if it does not exist" do
        expect(Vapor.mkdir("non-existing")).to match_array([true])
      end

      it "should recursively create a directories if they do not exist" do
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
