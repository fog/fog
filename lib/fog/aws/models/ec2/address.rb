module Fog
  module AWS
    class EC2

      class Address < Fog::Model

        identity  :public_ip,   'publicIp'

        attribute :instance_id, 'instanceId'

        def destroy
          connection.release_address(@public_ip)
          true
        end

        def instance=(new_instance)
          if new_instance
            associate(new_instance)
          else
            disassociate
          end
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

        def associate(new_instance)
          if new_record?
            @instance = new_instance
          else
            @instance = nil
            @instance_id = new_instance.instance_id
            connection.associate_address(@instance_id, @public_ip)
          end
        end

        def disassociate
          @instance = nil
          @instance_id = nil
          unless new_record?
            connection.disassociate_address(@public_ip)
          end
        end

      end

    end
  end
end
