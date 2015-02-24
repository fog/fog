module Fog
  module Compute
    class Ovirt
     class Real
        def remove_from_affinity_group(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "affinity group id is a required parameter for remove-from-affinity-group" unless options.key? :id
          client.delete_vm_from_affinity_group(options[:id], id)
        end
      end

      class Mock
        def remove_from_affinity_group(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "affinity group id is a required parameter for remove-from-affinity-group" unless options.key? :id
          true
        end
      end
    end
  end
end
