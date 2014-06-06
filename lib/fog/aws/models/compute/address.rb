require 'fog/core/model'

module Fog
  module Compute
    class AWS
      class Address < Fog::Model
        identity  :public_ip,                  :aliases => 'publicIp'

        attribute :allocation_id,              :aliases => 'allocationId'
        attribute :association_id,             :aliases => 'associationId'
        attribute :server_id,                  :aliases => 'instanceId'
        attribute :network_interface_id,       :aliases => 'networkInterfaceId'
        attribute :network_interface_owner_id, :aliases => 'networkInterfaceOwnerId'
        attribute :domain

        def initialize(attributes = {})
          # assign server first to prevent race condition with persisted?
          self.server = attributes.delete(:server)
          super
        end

        def destroy
          requires :public_ip

          service.release_address(allocation_id || public_ip)
          true
        end

        def server=(new_server)
          if new_server
            associate(new_server)
          else
            disassociate
          end
        end

        def server
          service.servers.get(server_id)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          data = service.allocate_address(domain).body
          new_attributes = data.reject {|key,value| key == 'requestId'}
          merge_attributes(new_attributes)
          if @server
            self.server = @server
          end
          true
        end

        private

        def associate(new_server)
          unless persisted?
            @server = new_server
          else
            @server = nil
            self.server_id = new_server.id
            service.associate_address(server_id, public_ip, network_interface_id, allocation_id)
          end
        end

        def disassociate
          @server = nil
          self.server_id = nil
          if persisted?
            service.disassociate_address(public_ip)
          end
        end
      end
    end
  end
end
