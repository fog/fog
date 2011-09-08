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
            :datacenter => "Falkenberg" || datacenter,
            :platform   => "Xen" || platform,
            :hostname   => hostname,
            :template   => "Debian-6 x64" || template,
            :disksize   => "10" || disksize,
            :memorysize => "512" || memorysize,
            :cpucores   => "1" || cpucores,
            :rootpw     => rootpw,
            :transfer   => "500" || transfer,
          } 
          data = connection.create(options)
          merge_attributes(data.body['response']['server'])
          data.status == 200 ? true : false
        end
        
      end
    end
  end
end
