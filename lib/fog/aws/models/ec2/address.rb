module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        attribute :instance_id, 'instanceId'
        attribute :public_ip,   'publicIp'

        def addresses
          @addresses
        end

        def delete
          connection.release_address(@public_ip)
          true
        end

        def save
          data = connection.allocate_address
          @public_ip = data.body['publicIp']
          true
        end

        private

        def addresses=(new_addresses)
          @addresses = new_addresses
        end

      end

    end
  end
end
