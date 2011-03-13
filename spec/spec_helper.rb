require "rspec"
require "webmock/rspec"
require "undertexter"
require "subtitle"
require "undertexter/error"

WebMock.allow_net_connect!

RSpec.configure do |config|
  config.mock_with :rspec
end
