module Fog
  module Compute
    class Ovirt
      class Real

        def update_interface(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "interface id is a required parameter for update-interface" unless options.has_key? :id

          client.update_interface(id, options)
        end

      end

      class Mock
        def update_interface(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "interface id is a required parameter for update-interface" unless options.has_key? :id
          true
        end

      end
    end
  end
end
