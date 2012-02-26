module Fog
  module Compute
    class Ovirt
      class Real

        def destroy_vm(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.has_key? :id
          client.destroy_vm(options[:id])
        end

      end

      class Mock
        def destroy_vm(options = {})
          raise ArgumentError, "instance id is a required parameter" unless options.has_key? :id
          true
        end

      end
    end
  end
end
