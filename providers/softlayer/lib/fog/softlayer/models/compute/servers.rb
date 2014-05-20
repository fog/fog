#
# Author:: Matt Eldridge (<matt.eldridge@us.ibm.com>)
# © Copyright IBM Corporation 2014.
#
# LICENSE: MIT (http://opensource.org/licenses/MIT)
#
require 'fog/core/collection'
require 'fog/softlayer/models/compute/server'

module Fog
  module Compute
    class Softlayer

      class Servers < Fog::Collection

        model Fog::Compute::Softlayer::Server

        def all
          data = service.list_servers
          load(data)
        end

        ## Get a SoftLayer server.
        #
        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          response = service.get_vm(identifier)
          if response.status == 404 # we didn't find it as a VM, look for a BMC server
            response = service.get_bare_metal_server(identifier)
          end
          data = response.body
          new.merge_attributes(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def bootstrap(options={})
          server = service.create(options)
          server.wait_for { ready? }
          server
        end

      end

    end
  end
end
