module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        attribute :instance_id, 'instanceId'
        attribute :public_ip,   'publicIp'

        def delete
          connection.release_address(@public_ip)
          true
        end

        def save
          data = connection.allocate_address
          @public_ip = data.body['publicIp']
          true
        end

      end

    end
  end
end
