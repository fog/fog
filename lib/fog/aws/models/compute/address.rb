require 'fog/model'

module Fog
  module AWS
    class Compute

      class Address < Fog::Model

        identity  :public_ip, :aliases => 'publicIp'

        attribute :server_id, :aliases => 'instanceId'

        def initialize(attributes = {})
          # assign server first to prevent race condition with new_record?
          self.server = attributes.delete(:server)
          super
        end

        def destroy
          requires :public_ip

          connection.release_address(@public_ip)
          true
        end

        def server=(new_server)
          if new_server
            associate(new_server)
          else
            disassociate
          end
        end

        def save
          data = connection.allocate_address
          @public_ip = data.body['publicIp']
          if @server
            self.server = @server
          end
          true
        end

        private

        def associate(new_server)
          if new_record?
            @server = new_server
          else
            @server = nil
            @server_id = new_server.id
            connection.associate_address(@server_id, @public_ip)
          end
        end

        def disassociate
          @server = nil
          @server_id = nil
          unless new_record?
            connection.disassociate_address(@public_ip)
          end
        end

      end

    end
  end
end
