require 'fog/core/collection'
require 'fog/linode/models/compute/server'

module Fog
  module Compute
    class Linode
      class Servers < Fog::Collection
        model Fog::Compute::Linode::Server

        def all
          load servers
        end

        def get(id)
          new servers(id).first
        rescue Fog::Compute::Linode::NotFound
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
