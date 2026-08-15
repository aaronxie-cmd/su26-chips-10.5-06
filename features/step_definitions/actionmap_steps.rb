# frozen_string_literal: true

require 'uri'

Given /^I am logged in via (github|google|developer) as (".*")/i do |provider, _data|
  page.find_link(text: "#{provider.capitalize} Login")
end

Given 'I visit the state page for {string}' do |state_symbol|
  visit state_map_path(state_symbol)
end

Given 'I visit the county page for {string} with FIPS code {string}' do |state_symbol, fips_code|
  visit county_path(
    state_symbol: state_symbol,
    std_fips_code: fips_code
  )
end

Then /I click the state "(\w\w)"/i do |state_symbol|
  expect(page).to have_css(
    "path[data-state-symbol='#{state_symbol}']"
  )

  visit state_map_path(state_symbol)
end

Then /I click the county "(.*)"/i do |county_name|
  county = find(
    "path[data-county-name='#{county_name}']",
    visible: :all
  )

  state_symbol = URI.parse(current_url).path.split('/')[2]

  visit county_path(
    state_symbol: state_symbol,
    std_fips_code: county['data-county-fips-code']
  )
end

Then /I click the county with FIPS Code "(.*)"/i do |fips_code|
  county = find(
    "path[data-county-fips-code='#{fips_code}']",
    visible: :all
  )

  expect(county).not_to be_nil

  state_symbol = URI.parse(current_url).path.split('/')[2]

  visit county_path(
    state_symbol: state_symbol,
    std_fips_code: fips_code
  )
end

Then 'I should see the county {string}' do |county_name|
  expect(page).to have_css(
    "path.actionmap-view-region[data-county-name='#{county_name}']",
    visible: :all,
    wait: 10
  )
end

Then /I should see (\d+) (?:states|counties)/i do |count|
  expect(page).to have_css(
    'path.actionmap-view-region',
    count: count.to_i,
    visible: :all,
    wait: 10
  )
end
