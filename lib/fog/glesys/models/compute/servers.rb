require 'fog/core/collection'
require 'fog/glesys/models/compute/server'

module Fog
  module Compute
    class Glesys

        class Servers < Fog::Collection

        model Fog::Compute::Glesys::Server

        def all
          data = connection.list_servers.body['response']['servers']
          load(data) 
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          details = connection.server_details(identifier).body['response']
          status  = connection.server_status(identifier).body['response']
          if details.empty? || status.empty?
            nil
          else
            status['server'].merge!({ :serverid => identifier})
            details['server'].merge!(status['server'])
            new(details['server'])
          end
        end

      end

    end
  end
end
