require "vcr"
require "kigo_connector"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.default_cassette_options = { record: :new_episodes, match_requests_on: [:body, :method, :headers, :uri] }
  c.hook_into :webmock
end
