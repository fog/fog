require 'fog'
require 'fog/bin'

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = ['aws', 'bluebox', 'brightbox', 'dnsimple', 'ecloud', 'gogrid', 'google', 'linode', 'local', 'newservers', 'rackspace', 'slicehost', 'voxel', 'zerigo']
available_providers = Fog.providers.map {|provider| provider.downcase}
for provider in (all_providers - available_providers)
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '~/.fog' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end
