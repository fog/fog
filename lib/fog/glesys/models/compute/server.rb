require 'fog/compute/models/server'

module Fog
  module Compute
    class Glesys

      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :serverid

        attribute :hostname
        attribute :datacenter
        attribute :cpucores
        attribute :memorysize
        attribute :disksize
        attribute :cpu
        attribute :memory
        attribute :disk
        attribute :uptime
        attribute :transfer
        attribute :templatename
        attribute :managedhosting
        attribute :platform
        attribute :cost
        attribute :rootpassword
        attribute :state
        attribute :iplist
        attribute :description
        attribute :glera_enabled, :aliases => "gleraenabled"
        attribute :supported_features, :aliases => "supportedfeatures"

        def ready?
          state == 'running'
        end

        def start
          requires :identity
          service.start(:serverid => identity)
        end

        def stop
          requires :identity
          service.stop(:serverid => identity)
        end

        def reboot
          requires :identity
          service.reboot(:serverid => identity)
        end

        def destroy(options = {})
          requires :identity
          service.destroy(options.merge!({:serverid => identity}))
        end

        def save
          raise "Operation not supported" if self.identity
          requires :hostname, :rootpassword

          options = {
            :datacenter     => datacenter   || "Falkenberg",
            :platform       => platform     || "Xen",
            :hostname       => hostname,
            :templatename   => templatename || "Debian-6 x64",
            :disksize       => disksize     || "10",
            :memorysize     => memorysize   || "512",
            :cpucores       => cpucores     || "1",
            :rootpassword   => rootpassword,
            :transfer       => transfer     || "500",
          }
          data = service.create(options)
          merge_attributes(data.body['response']['server'])
          data.status == 200 ? true : false
        end

        def public_ip_address(options = {})

          type = options[:type] || nil

          ips = case type
            when :ipv4 then iplist.select { |ip| ip["version"] == 4 }
            when :ipv6 then iplist.select { |ip| ip["version"] == 6 }
            else iplist.sort_by { |ip| ip["version"] }
          end

          if ips.empty?
            nil
          else
            ips.first["ipaddress"]
          end
        end

      end
    end
  end
end
