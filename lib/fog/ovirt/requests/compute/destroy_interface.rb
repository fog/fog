module Fog
  module Compute
    class Ovirt
      class Real

        def destroy_interface(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "interface id is a required parameter for destroy-interface" unless options.has_key? :id

          client.destroy_interface(id, options[:id])
        end

      end

      class Mock
        def destroy_interface(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "interface id is a required parameter for destroy-interface" unless options.has_key? :id
          true
        end

      end
    end
  end
end
