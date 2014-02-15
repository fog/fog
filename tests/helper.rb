require 'simplecov'

if ENV['COVERAGE'] == 'true' && RUBY_VERSION != "1.9.2"
  require 'coveralls'
  SimpleCov.command_name "shindo:#{Process.pid.to_s}"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.merge_timeout 3600
  SimpleCov.start
end

ENV['FOG_RC']         = ENV['FOG_RC'] || File.expand_path('../.fog', __FILE__)
ENV['FOG_CREDENTIAL'] = ENV['FOG_CREDENTIAL'] || 'default'

require 'fog'
require 'fog/bin' # for available_providers and registered_providers

Excon.defaults.merge!(:debug_request => true, :debug_response => true)

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

def array_differences(array_a, array_b)
  (array_a - array_b) | (array_b - array_a)
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = Fog.registered_providers.map {|provider| provider.downcase}

# Manually remove these providers since they are local applications, not lacking credentials
all_providers = all_providers - ["libvirt", "vmfusion", "openvz"]

available_providers = Fog.available_providers.map {|provider| provider.downcase}

unavailable_providers = all_providers - available_providers

if !ENV['PROVIDER'].nil? && unavailable_providers.include?(ENV['PROVIDER'])
  Formatador.display_line("[red]Requested provider #{ENV['PROVIDER']} is not available.[/]" + 
                          "[red]Check if .fog file has correct configuration (see '#{Fog.credentials_path}')[/]")
  exit(0)
end

for provider in unavailable_providers
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '#{Fog.credentials_path}' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end

# mark libvirt tests pending if not setup
begin
  require('ruby-libvirt')
rescue LoadError
  Formatador.display_line("[yellow]Skipping tests for [bold]libvirt[/] [yellow]due to missing `ruby-libvirt` gem.[/]")
  Thread.current[:tags] << '-libvirt'
end
