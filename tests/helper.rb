require 'fog'
require 'fog/bin' # for available_providers

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = ['aws', 'bluebox', 'brightbox', 'dnsimple', 'dnsmadeeasy', 'dynect', 'ecloud', 'glesys', 'gogrid', 'google', 'linode', 'local', 'ninefold', 'newservers', 'rackspace', 'slicehost', 'stormondemand', 'voxel', 'zerigo']
available_providers = Fog.available_providers.map {|provider| provider.downcase}
for provider in (all_providers - available_providers)
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '~/.fog' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end
