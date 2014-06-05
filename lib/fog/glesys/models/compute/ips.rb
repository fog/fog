require 'fog/core/collection'
require 'fog/glesys/models/compute/ip'

module Fog
  module Compute
    class Glesys
      class Ips < Fog::Collection
        model Fog::Compute::Glesys::Ip

        attribute :serverid
        attribute :server

        def all
          attributes = {}
          attributes[:serverid] = serverid unless serverid.nil?
          ips  = service.ip_list_own(attributes).body['response']['iplist']
          load(ips)
        end

        def get(ip)
          data = service.ip_details( :ipaddress => ip).body['response']['details']
          new data
        end

        def attached
          all.select { |ip| !ip.serverid.nil? }
        end

        def available
          all.select { |ip| ip.serverid.nil? }
        end

        def free(options = {})
          default_options = {
            :version => 4
          }

          if !server.nil?
            default_options[:datacenter] = server.datacenter
            default_options[:platform] = server.platform
          end

          options = default_options.merge!(options)

          %w{platform datacenter version}.each do |attr|
            raise Fog::Errors::Error.new("You need to specify ':#{attr}'") if !options.key?(attr.to_sym)
          end

          options[:ipversion] = options[:version]
          options.delete(:version)

          service.ip_list_free(options).body["response"]["iplist"]["ipaddresses"]
        end

        def take(ip, options = {})
          default_options = {
            :attach => false
          }

          options = default_options.merge!(options)

          data = service.ip_take(
            :ipaddress => ip_from_object(ip)
          ).body["response"]["details"]

          ip = new data

          if options[:attach] && serverid
            server.ips.attach ip, serverid
            ip.serverid = serverid
          end

          ip
        end

        def release(ip)
          service.ip_release(
            :ipaddress => ip_from_object(ip)
          )
        end

        def attach(ip, server_id=nil)
          if server_id.nil?
            server_id = serverid
          end

          if server_id.nil?
            raise Fog::Errors::Error.new("You need to specify a server id")
          end

          server_id = server_id.serverid if server_id.is_a?(Fog::Compute::Glesys::Server)

          service.ip_add(
            :ipaddress => ip_from_object(ip),
            :serverid  => server_id
          )

          if server.nil?
            true
          else
            server.reload
          end
        end

        def remove(ip, options = {})
          new service.ip_remove({:ipaddress => ip_from_object(ip)}.merge!(options)).data.body["response"]["details"]
        end

        private

        def ip_from_object(ip)
          ip.is_a?(Fog::Compute::Glesys::Ip) ? ip.ip : ip
        end
      end
    end
  end
end
