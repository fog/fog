module Fog
  module Compute
    class Ovirt

      module Shared
        def check_arguments(id, options)
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "interface id is a required parameter for update-interface" unless options.key? :id
        end
      end

      class Real
        extend ::Fog::Compute::Ovirt::Shared

        def update_interface(id, options)
          check_arguments(id, options)

          interface_id = options[:id]
          options.delete(:id)

          client.update_interface(id, interface_id, options)
        end
      end

      class Mock
        extend ::Fog::Compute::Ovirt::Shared

        def update_interface(id, options)
          check_arguments(id, options)
          true
        end
      end
    end
  end
end
