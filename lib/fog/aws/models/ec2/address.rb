module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        attribute :instance_id, 'instanceId'
        attribute :public_ip,   'publicIp'

        def addresses
          @addresses
        end

        def initialize(new_attributes = {})
          new_attributes = {
            :instance_id => ''
          }.merge!(new_attributes)
          super(new_attributes)
        end

        def destroy
          connection.release_address(@public_ip)
          true
        end

        def instance=(new_instance)
          if !@public_ip
            @instance = new_instance
          elsif new_instance
            @instance = nil
            @instance_id = new_instance.instance_id
            connection.associate_address(@instance_id, @public_ip)
          end
        end

        def reload
          new_attributes = addresses.get(@public_ip).attributes
          merge_attributes(new_attributes)
        end

        def save
          data = connection.allocate_address
          @public_ip = data.body['publicIp']
          if @instance
            self.instance = @instance
          end
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
