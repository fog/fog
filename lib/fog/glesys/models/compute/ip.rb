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

        def list_own
          service.list_own
        end

        def list_free
          requires :version, :datacenter, :platform
          service.ip_list_free(
            :ipversion => version,
            :platform => platform,
            :datacenter => datacenter
          ).body['response']['iplist']
        end

        def details
          requires :version, :ip
          service.ip_details(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def take
          requires :version, :ip
          service.ip_take(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def release
          requires :version, :ip
          service.ip_release(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def add
          requires :serverid, :version, :ip
          service.ip_add(
            :serverid  => serverid,
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def remove
          requires :serverid, :version, :ip
          service.ip_remove(
            :serverid  => serverid,
            :ipversion => version,
            :ipaddress => ip
          )
        end

      end
    end
  end
end
