# frozen_string_literal: true

require 'webmock/cucumber'
WebMock.disable_net_connect!(allow_localhost: true)

Before do
  stub_request(:post, /api\.geocod\.io/).to_return(
    status: 200,
    body: Rails.root.join('spec/fixtures/geocodio_response.json').read,
    headers: { 'Content-Type' => 'application/json' }
  )
end

# intercept POST requests to the Geocodio API and return a stubbed response from a fixture file.
# This allows for testing without making actual API calls.
# gemini blockcode, review if errors come back here
