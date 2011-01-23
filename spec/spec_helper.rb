require 'rspec'

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
end
