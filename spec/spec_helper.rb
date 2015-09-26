require "bundler/setup"
Bundler.setup

require "webmock/rspec"

require "simplecov"
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter "spec"
end

require "vapor"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = "random"

  # WebMock.stub_request(:propfind, "http://www.hoppinger.com/test").
  #        with(body: "<?xml version=\"1.0\" encoding=\"utf-8\"?><DAV:propfind xmlns:DAV=\"DAV:\"><DAV:allprop/></DAV:propfind>").
  #        to_return(status: 200, body: "", headers: {})
end
