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
        attribute :transfer
        attribute :template
        attribute :managedhosting
        attribute :platform
        attribute :cost
        attribute :rootpw
        attribute :keepip
        attribute :state
        attribute :iplist
        attribute :ipversion
        attribute :ip

        def ready?
          state == 'running'
        end

        def start
          requires :identity
          connection.start(:serverid => identity) 
        end

        def stop
          requires :identity
          connection.stop(:serverid => identity)
        end

        def destroy
          requires :identity
          connection.destroy(:serverid => identity, :keepip => keepip)
        end

        def save
          raise "Operation not supported" if self.identity
          requires :hostname, :rootpw

          options = {
            :datacenter => datacenter || "Falkenberg",
            :platform   => platform || "Xen",
            :hostname   => hostname,
            :template   => template || "Debian-6 x64",
            :disksize   => disksize || "10",
            :memorysize => memorysize || "512",
            :cpucores   => cpucores || "1",
            :rootpw     => rootpw,
            :transfer   => transfer || "500",
          } 
          data = connection.create(options)
          merge_attributes(data.body['response']['server'])
          data.status == 200 ? true : false
        end
        
      end
    end
  end
end
