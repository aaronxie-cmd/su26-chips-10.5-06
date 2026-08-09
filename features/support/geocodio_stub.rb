require 'webmock/cucumber'

WebMock.disable_net_connect!(allow_localhost: true)

Before do
  geocodio_response = {
    'results' => [
      {
        'response' => {
          'results' => [
            {
              'fields' => {
                'congressional_districts' => [
                  {
                    'name' => 'Congressional District 12',
                    'district_number' => 12,
                    'ocd_id' => 'ocd-division/country:us/state:ca/cd:12',
                    'current_legislators' => [
                      {
                        'type' => 'representative',
                        'bio' => {
                          'first_name' => 'Jane',
                          'last_name' => 'Doe',
                          'party' => 'Democrat',
                          'gender' => 'F'
                        },
                        'contact' => {
                          'url' => 'https://example.com',
                          'address' => '1234 Longworth House Office Building; Washington DC 20515',
                          'phone' => '202-225-0000'
                        },
                        'social' => {
                          'twitter' => 'repjanedoe'
                        },
                        'references' => {
                          'bioguide_id' => 'D000000',
                          'govtrack_id' => '412345'
                        }
                      }
                    ]
                  }
                ]
              }
            }
          ]
        }
      }
    ]
  }

  stub_request(:post, /api\.geocod\.io/)
    .to_return(
      status: 200,
      body: geocodio_response.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
end
