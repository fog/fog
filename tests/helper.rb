ENV['FOG_RC']         = ENV['FOG_RC'] || File.expand_path('../.fog', __FILE__)
ENV['FOG_CREDENTIAL'] = ENV['FOG_CREDENTIAL'] || 'default'

require 'fog'
require 'fog/bin' # for available_providers and registered_providers
require 'ostruct'

Excon.defaults.merge!(:debug_request => true, :debug_response => true)

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

# This overrides the default 600 seconds timeout during live test runs
if Fog.mocking?
  FOG_TESTING_TIMEOUT = ENV['FOG_TEST_TIMEOUT'] || 2000
  Fog.timeout = 2000
  Fog::Logger.warning "Setting default fog timeout to #{Fog.timeout} seconds"

  # These sets of tests do not behave nicely when running mocked tests
  Thread.current[:tags] << '-xenserver'
  Thread.current[:tags] << '-joyent'
  Thread.current[:tags] << '-dreamhost'
else
  FOG_TESTING_TIMEOUT = Fog.timeout
end

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

def array_differences(array_a, array_b)
  (array_a - array_b) | (array_b - array_a)
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = Fog.registered_providers.map {|provider| provider.downcase}

# Manually remove these providers since they are local applications, not lacking credentials
all_providers = all_providers - ["openvz"]

available_providers = Fog.available_providers.map {|provider| provider.downcase}

unavailable_providers = all_providers - available_providers

if !ENV['PROVIDER'].nil? && unavailable_providers.include?(ENV['PROVIDER'])
  Fog::Formatador.display_line("[red]Requested provider #{ENV['PROVIDER']} is not available.[/]" +
                          "[red]Check if .fog file has correct configuration (see '#{Fog.credentials_path}')[/]")
  exit(0)
end

for provider in unavailable_providers
  Fog::Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '#{Fog.credentials_path}' to run them)[/]")
end
