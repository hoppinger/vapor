require "bundler/setup"
Bundler.setup

require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

require "simplecov"
require "simplecov-rcov"
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  add_filter "spec"
end

require "vapor"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = "random"

  config.before(:each) do
    stub_request(:propfind, "http://www.hoppinger.com/test/non-existing").to_return(status: 500, body: "", headers: {})
    stub_request(:propfind, "http://www.hoppinger.com/test/existing/non-existing").to_return(status: 500, body: "", headers: {})
    stub_request(:propfind, "http://www.hoppinger.com/test/non-existing.file").to_return(status: 500, body: "", headers: {})

    stub_request(:mkcol, "http://www.hoppinger.com/test/non-existing").to_return(status: 200, body: "", headers: {})
    stub_request(:propfind, "http://www.hoppinger.com/test/non-existing/non-existing").to_return(status: 200, body: "", headers: {})
    stub_request(:mkcol, "http://www.hoppinger.com/test/existing/non-existing").to_return(status: 200, body: "", headers: {})

    stub_request(:propfind, "http://www.hoppinger.com/test/existing.file").to_return(status: 200, body: "", headers: {})
    stub_request(:propfind, "http://www.hoppinger.com/test/existing").to_return(status: 200, body: "", headers: {})
    stub_request(:delete, "http://www.hoppinger.com/test/existing.file").to_return(status: 200, body: "", headers: {})
  end
end
