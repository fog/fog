require 'fog'
require 'fog/bin' # for available_providers

require File.expand_path(File.join(File.dirname(__FILE__), 'helpers', 'mock_helper'))

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

def array_differences(array_a, array_b)
  (array_a - array_b) | (array_b - array_a)
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = ['aws', 'bare_metal_cloud', 'bluebox', 'brightbox', 'cloudstack', 'dnsimple', 'dnsmadeeasy', 'dynect', 'ecloud', 'glesys', 'gogrid', 'google', 'hp', 'linode', 'local', 'ninefold', 'openstack', 'rackspace', 'stormondemand', 'voxel', 'xenserver', 'zerigo']
available_providers = Fog.available_providers.map {|provider| provider.downcase}
for provider in (all_providers - available_providers)
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '~/.fog' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end

# mark libvirt tests pending if not setup
begin
  require('ruby-libvirt')
rescue LoadError
  Formatador.display_line("[yellow]Skipping tests for [bold]libvirt[/] [yellow]due to missing `ruby-libvirt` gem.[/]")
  Thread.current[:tags] << '-libvirt'
end
