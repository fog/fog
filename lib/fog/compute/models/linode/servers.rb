require 'fog/core/collection'
require 'fog/compute/models/linode/server'

module Fog
  module Linode
    class Compute
      class Servers < Fog::Collection
        model Fog::Linode::Compute::Server

        def all
          load servers
        end

        def get(id)
          new servers(id).first
        rescue Fog::Linode::Compute::NotFound
          nil
        end

        private
        def servers(id=nil)
          connection.linode_list(id).body['DATA'].map { |server| map_server server }
        end
        
        def map_server(server)
          server = server.each_with_object({}) { |(k, v), h| h[k.downcase.to_sym] = v  }
          server.merge! :id => server[:linodeid], :name => server[:label]
        end
      end
    end
  end
end
