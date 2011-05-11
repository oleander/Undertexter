require "rspec"
require "webmock/rspec"
require "undertexter"
require "vcr"
require "subtitle"
require "undertexter/error"

WebMock.allow_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec
  config.extend VCR::RSpec::Macros
end

VCR.config do |c|
  c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  c.stub_with :webmock
  c.default_cassette_options = {
    record: :all
  }
  c.allow_http_connections_when_no_cassette = false
end
