$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), %w[ .. lib fog]))

require 'fog'
require 'fog/bin'

# Use so you can run in mock mode from the command line
#
# FOG_MOCK=true fog

if ENV["FOG_MOCK"] == "true"
  Fog.mock!
end

# check to see which credentials are available and add others to the skipped tags list
all_providers = ['aws', 'bluebox', 'brightbox', 'gogrid', 'google', 'linode', 'local', 'newservers', 'rackspace', 'slicehost', 'terremark']
available_providers = Fog.providers.map {|provider| provider.to_s.downcase}
for provider in (all_providers - available_providers)
  Formatador.display_line("[yellow]Skipping tests for [bold]#{provider}[/] [yellow]due to lacking credentials (add some to '~/.fog' to run them)[/]")
  Thread.current[:tags] << ('-' << provider)
end

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end
