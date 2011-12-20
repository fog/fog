require 'rubygems'
require 'shindo'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')
require File.join(File.dirname(__FILE__), '..', 'tests', 'helper')

Shindo.tests('compute examples', 'compute') do

  # iterate over all the providers
  Fog.providers.values.each do |provider|

    # FIXME: implement expected shared compute stuff for these providers as well
    next if ['Bluebox', 'Brightbox', 'Ecloud', 'GoGrid', 'Linode', 'NewServers', 'Ninefold', 'Slicehost', 'StormOnDemand', 'VirtualBox', 'Voxel'].include?(provider)

    provider = eval(provider) # convert from string to object

    # skip if provider does not have compute
    next unless provider.respond_to?(:services) && provider.services.include?(:compute)

    tests(provider, provider.to_s.downcase) do

      # use shortcuts to instantiate connection
      @compute = Fog::Compute.new(:provider => provider.to_s)

      # create a server
      tests('@server = @compute.servers.bootstrap').succeeds do
        @server = @compute.servers.bootstrap
      end

      # list servers
      tests('@servers = @compute.servers').succeeds do
        @servers = @compute.servers
      end

      # get a server
      tests('@compute.servers.get(@server.identity)').succeeds do
        @compute.servers.get(@server.identity)
      end

      # ssh to a server
      tests('@server.ssh("pwd")').succeeds do
        @server.ssh('pwd')
      end

      # scp a file to a server
      lorem_path = File.join([File.dirname(__FILE__), '..', 'tests', 'lorem.txt'])
      tests("@server.scp_upload('#{lorem_path}', 'lorem.txt')").succeeds do
        @server.scp_upload(lorem_path, 'lorem.txt')
      end

      # scp a file from a server
      tests("@server.scp_download('lorem.txt', '/tmp/lorem.txt)").succeeds do
        @server.scp_download('lorem.txt', '/tmp/lorem.txt')
      end
      File.delete('/tmp/lorem.txt')

      # scp a directory to a server
      Dir.mkdir('/tmp/lorem')
      file = ::File.new('/tmp/lorem/lorem.txt', 'w')
      file.write(File.read(lorem_path))
      tests("@server.scp_upload('/tmp/lorem', '/tmp', :recursive => true)").succeeds do
        @server.scp_upload('/tmp/lorem', '/tmp', :recursive => true)
      end
      File.delete('/tmp/lorem/lorem.txt')
      Dir.rmdir('/tmp/lorem')

      # scp a directory from a server
      tests("@server.scp_download('/tmp/lorem', '/tmp', :recursive => true)").succeeds do
        @server.scp_download('/tmp/lorem', '/tmp', :recursive => true)
      end
      File.delete('/tmp/lorem/lorem.txt')
      Dir.rmdir('/tmp/lorem')

      # destroy the server
      tests('@server.destroy').succeeds do
        @server.destroy
      end

    end

  end

end
