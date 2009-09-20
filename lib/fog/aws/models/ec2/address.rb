module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        attribute :instance_id, 'instanceId'
        attribute :public_ip,   'publicIp'

        def addresses
          @addresses
        end

        def destroy
          connection.release_address(@public_ip)
          true
        end

        def reload
          new_attributes = addresses.all(@public_ip).first.attributes
          merge_attributes(new_attributes)
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
