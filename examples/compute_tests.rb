require 'rubygems'
require 'shindo'

require File.join(File.dirname(__FILE__), '..', 'lib', 'fog')
require File.join(File.dirname(__FILE__), '..', 'tests', 'helper')

Shindo.tests('compute examples', 'compute') do

  # iterate over all the providers
  Fog.providers.each do |provider|

    provider = eval(provider) # convert from string to object

    # skip if provider does not have storage
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
      tests("@server.scp('#{lorem_path}', 'lorem.txt')").succeeds do
        @server.scp(lorem_path, 'lorem.txt')
      end

      # scp a directory to a server
      lorem_dir = File.join([File.dirname(__FILE__), '..', 'tests'])
      tests("@server.scp('#{lorem_dir}', '/tmp/lorem', :recursive => true)").succeeds do
        @server.scp(lorem_dir, '/tmp/lorem', :recursive => true)
      end

      # destroy the server
      tests('@server.destroy').succeeds do
        @server.destroy
      end

    end

  end

end
