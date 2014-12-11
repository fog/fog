module Fog
  module Rackspace
    class NetworkingV2
      class Subnet < Fog::Model

        identity :id

        attribute :name
        attribute :enable_dhcp
        attribute :network_id
        attribute :tenant_id
        attribute :dns_nameservers
        attribute :allocation_pools
        attribute :host_routes
        attribute :ip_version
        attribute :gateway_ip
        attribute :cidr

        def save
          data = unless self.id.nil?
            service.update_subnet(self)
          else
            service.create_subnet(self)
          end

          merge_attributes(data.body['subnet'])
          true
        end

        def destroy
          requires :identity
          service.delete_subnet(identity)
          true
        end
      end
    end
  end
end
