require 'fog/core/model'

module Fog
  module Glesys
    class Compute

      class Ip < Fog::Model
        extend Fog::Deprecation

        identity :serverid

        attribute :datacenter
        attribute :version
        attribute :platform
        attribute :ip

        def list_own
          connection.list_own
        end

        def list_free
          requires :version, :datacenter, :platform
          connection.ip_list_free(
            :ipversion => version,
            :platform => platform,
            :datacenter => datacenter
          ).body['response']['iplist']
        end

        def details
          requires :version, :ip
          connection.ip_details(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def take
          requires :version, :ip
          connection.ip_take(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def release
          requires :version, :ip
          connection.ip_release(
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def add
          requires :serverid, :version, :ip
          connection.ip_add(
            :serverid  => serverid,
            :ipversion => version,
            :ipaddress => ip
          )
        end

        def remove
          requires :serverid, :version, :ip
          connection.ip_remove(
            :serverid  => serverid,
            :ipversion => version,
            :ipaddress => ip
          )
        end

      end
    end
  end
end
