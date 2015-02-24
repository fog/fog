module Fog
  module Compute
    class Ovirt
      class Real
        def add_to_affinity_group(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "affinity group id is a required parameter for add-to-affinity-group" unless options.key? :id
          client.add_vm_to_affinity_group(options[:id], id)
        end
      end

      class Mock
        def add_to_affinity_group(id, options = {})
          raise ArgumentError, "instance id is a required parameter" unless id
          raise ArgumentError, "affinity group id is a required parameter for add-to-affinity-group" unless options.key? :id
          true
        end
      end
    end
  end
end
