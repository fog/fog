require 'fog/core/model'

module Fog
  module Compute
    class Glesys
      class Ip < Fog::Model
        extend Fog::Deprecation

        identity :ip

        attribute :ip, :aliases => "ipaddress"
        attribute :datacenter
        attribute :version, :aliases => "ipversion"
        attribute :platform
        attribute :netmask
        attribute :broadcast
        attribute :gateway
        attribute :nameservers
        attribute :serverid
        attribute :reserved
        attribute :ptr
        attribute :cost

        def attached?
          !serverid.nil?
        end

        # Return an unused ip-address to the pool of free ips.
        def release
          requires :ip
          raise Fog::Errors::Error.new('You can\'t release a ip that is attached to a server') if attached?
          service.ip_release(
            :ipaddress => identity
          )
        end

        # Add an ip-adress to the server.
        def attach(server)
          requires :ip
          server = server.serverid if server.is_a?(Fog::Compute::Glesys::Server)
          raise Fog::Errors::Error.new("Ip is already attached to a server, #{serverid}") unless serverid.nil?
          data = service.ip_add(
            :ipaddress => identity,
            :serverid  => server
          ).body["response"]["details"]
          merge_attributes data
        end

        # Remove an ip from the server
        def remove(options = {})
          requires :ip
          raise Fog::Errors::Error.new('Ip is not attached to a server.') if serverid.nil?
          data = service.ip_remove({:ipaddress => ip}.merge!(options)).body["response"]["details"]
          merge_attributes data
        end

        # Remove the ip from a server and release it
        def destroy
          requires :ip
          remove(:release => true)
        end

        def take
          requires :ip
          data = service.ip_take(
            :ipaddress => ip
          ).body["response"]["details"]
          merge_attributes data
        end
      end
    end
  end
end
