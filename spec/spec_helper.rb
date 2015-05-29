require "json-encodable"
require "rspec/json_matcher"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include RSpec::JsonMatcher
end
