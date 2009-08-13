module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        attr_accessor :instance_id, :public_ip

        def initialize(attributes = {})
          remap_attributes(attributes, {
            'instanceId'  => :instance_id,
            'publicIp'    => :public_ip
          })
          super
        end

        def delete
          return false if new_record?
          connection.release_address(@public_ip)
          @new_record = true
          true
        end

        def save
          data = connection.allocate_address
          @public_ip = data.body['publicIp']
          @new_record = false
          true
        end

      end

    end
  end
end
